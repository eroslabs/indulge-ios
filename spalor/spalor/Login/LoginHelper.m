//
//  LoginHelper.m
//  spalor
//
//  Created by Manish on 25/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "LoginHelper.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LocationHelper.h"
#import "User.h"
#import "Constants.h"
#import "NetworkHelper.h"
#import "CustomTabbarController.h"

@interface LoginHelper(){
    int loginretry;
}
@property BOOL checking;
@end

@implementation LoginHelper

+(LoginHelper *)sharedInstance {
    static LoginHelper *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
        
    });
    return _sharedClient;
}



-(void)connectWithFacebook{
    //No token data so new install
    [FBSession.activeSession closeAndClearTokenInformation];

    NSArray *permissions = @[@"email", @"user_birthday"];
    [self loginToFacebookWithPermissions:permissions];
}

-(void)loginToFacebookWithPermissions:(NSDictionary *)permissions{
    
    
    if ([[FBSession activeSession] isOpen])
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,NSDictionary<FBGraphUser> *guser,NSError *error) {
             if (error == nil) {
                 User *user = [[User alloc] init];

                 if (FBSession.activeSession.accessTokenData.accessToken) {
                     //For Testing
                     //fbtoken = @"CAAIkq35CvdoBABMixHW9A9WxJiWmsVK9Gg77jVcUcNP5qLVz57tjVmOTGMTGzEoJ4mVbId7d7nF0lEA2CHj0IDIsCTqwz9kpsD9EgqcnNjD80wZBLM9zS2hZAl4ZBd5GRsESrx6NYLTwcZAFc4V37us9x4bp03tZAfXdpJqV913LFCBSpwmo2PqOZAOfDNnxClyI744mUMnBzXAXJliaXfY7naINLZBoZBIZD";
                     //fbtoken = @"CAAIkq35CvdoBAFcd8YOHEZCvRoXWvS5NoaJ3iyGfQXv5NXMj4l538F2xIDNLSAvhfaPgJu2lNHTICQS8j5FSFv3ysFZA5LpUQFmGu7VizoRylFhZC9QjGhrXhrw93DTI1np8tyy3f323vAH73GyMlZBz66o1pZB0T0ZBg4SDBK4X40CgNyTM62fkkwt97bzimt23ZCmh1wZA0ZAuRBZAZBKgRE4mORZBMg96TsSgQD1A4wqKxQZDZD";
                     
                     NSString *fbtoken = FBSession.activeSession.accessTokenData.accessToken;
                     user.facebookId = guser[@"id"];
                     user.name = guser.name;
                     user.dob = guser[@"birthday"];
                     user.mail = guser[@"email"];
                     
                     user.gender = ([guser[@"gender"] isEqualToString:@"male"])?@"0":@"1";
                     
                     DLog(@" FB USER %@",guser);
                     NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                     [user saveArchivedUserData:archivedUser];
                     
                     [self userLoggedInwithFBUserObject:user];
                 }
                 else{
                     [FBSession.activeSession closeAndClearTokenInformation];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:@"Sorry! We were not able to connect to Facebook, please check your connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         [alert show];
                         [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:nil];
                         
                     });
                 }
                 
                 NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",guser.id]]];
                 [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                     
                     if (error == nil) {
                        
                             user.imageData = data;
                             NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                             [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             
                         
                     }
                     else {
                         [FBSession.activeSession closeAndClearTokenInformation];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:@"Sorry! We were not able to connect to Facebook, please check your connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                             [alert show];
                             [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:nil];

                         });

                     }
                 }];
                 
             }

             else{
                 [FBSession.activeSession closeAndClearTokenInformation];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:@"Sorry! We were not able to connect to Facebook, please check your connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert show];
                     [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:nil];

                 });
             }
         }];
    }
    else{
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
        [self openActiveSessionWithPermissions:permissions];
    }
    
}

-(void)openActiveSessionWithPermissions:(NSDictionary *)permissions{
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        DLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        [FBSession.activeSession closeAndClearTokenInformation];
        
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             [self sessionStateChanged:session state:state error:error];
         }];
    }
    
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        DLog(@"Session opened");
        // Show the user the logged-in UI
        [self loginToFacebookWithPermissions:session.permissions];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        DLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
        return;
    }
    
    // Handle errors
    if (error){
        DLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                DLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:nil];

        }
        
        // Clear this token
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    [self notifyLoggedOut];
    //[self showMessage:@"You're now logged out" withTitle:@""];
}


// Show the user the logged-in UI
- (void)userLoggedInwithFBUserObject:(User *)user
{
    
   
    NSDictionary *userDict = @{@"name":user.name,@"facebook":user.facebookId,@"gender":user.gender,@"dob":user.dob,@"mail":user.mail};
    
    [[NetworkHelper sharedInstance] getArrayFromPostURL:@"user/save" parmeters:@{@"user":userDict} completionHandler:^(id response, NSString *url, NSError *error){
        if (error == nil && response!=nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            if (responseDict[@"user_id"]) {
                user.userId = responseDict[@"user_id"];
                NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_PASSED object:nil];
            }
            else{
                //Show Error Alert
                [FBSession.activeSession closeAndClearTokenInformation];

                [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:nil];

            }
            
           
        }
        else{
            //Show Error alert
            [FBSession.activeSession closeAndClearTokenInformation];

            [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAILED object:nil];

        }
    }];
    
    
}

-(void)updateDeviceToken:(NSString *)deviceToken{
    NSDictionary *params = @{
                             @"device_type":@"iphone",
                             @"device_token":deviceToken};
    
    [[NetworkHelper sharedInstance] getArrayFromPutURL:@"device_info" parmeters:params completionHandler:^(id response, NSString *url, NSError *error){
        
        NSLog(@"response %@",response);
        
    }];
}


-(void)notifyAuthenticated{
    self.checking = NO;
    NSDictionary *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"] ;
    NSDictionary *user = [token objectForKey:@"user"]  ;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Authenticated" object:nil];
}

-(void)notifyLoggedOut{
    self.checking = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthenticationFailed" object:nil];
}

-(void)notifyConnectingToFacebook{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchingFacebookImage" object:nil];
    
}

-(void)notifyConnectingToThrill{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggingToServer" object:nil];
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}


-(void)storeImageData:(NSData *)imageData ForId:(NSString *)pictureId applyBlur:(BOOL)applyBlur{
    NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                        inDomains:NSUserDomainMask] lastObject];
    
    NSString *imagePath =[documentsDirectory.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",pictureId]];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImage *endImage;
    
    if (applyBlur) {
        endImage = [self blur:image];
    }
    else{
        endImage = image;
    }
    
    
    NSData *endImageData = UIImagePNGRepresentation(endImage);
    
    if (![endImageData writeToFile:imagePath atomically:NO])
    {
        DLog(@"Failed to cache image data to disk");
    }
    else
    {
        DLog(@"IMAGE SAVED");
    }
}

- (UIImage*) blur:(UIImage*)theImage
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:6.0] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

@end
