//
//  LoginViewController.m
//  spalor
//
//  Created by Manish on 05/02/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "LoginViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "NetworkHelper.h"
#import "UIImage+ImageEffects.h"
#import "CustomTabbarController.h"
#import "User.h"
#import "NetworkHelper.h"
#import "LoginHelper.h"
#import "FeSpinnerTenDot.h"

@interface LoginViewController (){
    User *user;
    FeSpinnerTenDot *spinner;

}

@end

@implementation LoginViewController
static NSString * const kClientId = @"93816802333-n1e12l22i9o96ggukhjdh05ldes3738a.apps.googleusercontent.com";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.backgroundImageView.image = [self.backgroundImageView.image applyCustomEffectWithWhite:0.5 andAlpha:0.3];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.loginView = [[FBLoginView alloc] initWithReadPermissions:
//                      @[@"public_profile", @"email", @"user_birthday"]];
//    
//    self.loginView.center = self.view.center;
//    
//    self.loginView.frame = self.loginButton.frame;
//    
//    self.loginView.delegate = self;
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    self.loginButton.layer.cornerRadius = 2.0f;
    self.loginButton.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn) name:USER_LOGIN_PASSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginFailed) name:USER_LOGIN_FAILED object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {

    BOOL authenticated = [[NSUserDefaults standardUserDefaults] boolForKey:@"AUTHENTICATED"];
    
    if(authenticated)  // authenticated---> BOOL Value assign True only if Login Success
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CustomTabbarController *obj=(CustomTabbarController *)[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:obj animated:YES];
    }
    else {
        // Show Login email id fields
    }
    
}

-(IBAction)facebookLogin:(id)sender{
    spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
    [self.loaderContainerView addSubview:spinner];
    self.loaderContainerView.hidden = NO;
    [spinner showWhileExecutingSelector:@selector(loginToFacebook) onTarget:self withObject:nil];

}

-(void)loginToFacebook{
    [[LoginHelper sharedInstance] connectWithFacebook];

}

-(void)loggedIn{

    //Send data via login API
    
    BOOL authenticated = [[NSUserDefaults standardUserDefaults] boolForKey:@"AUTHENTICATED"];

    if(!authenticated)  // authenticated---> BOOL Value assign True only if Login Success
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AUTHENTICATED"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner dismiss];
            self.loaderContainerView.hidden = YES;
            
            CustomTabbarController *obj=(CustomTabbarController *)[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
            self.navigationController.navigationBarHidden=YES;
            [self.navigationController pushViewController:obj animated:YES];
        });

        
    }


}

-(void)userLoginFailed{
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner dismiss];
        self.loaderContainerView.hidden = YES;

    });

}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        //Show Error Alert
    }
    else{
        
        [self performSelector:@selector(loggedIn) withObject:nil afterDelay:2.0f];

    }
}

// Call method when user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)guser {
    self.profilePictureView.profileID = guser.id;
    user = [[User alloc] init];
    user.name = guser[@"name"];
    user.gender = guser[@"gender"];
    user.facebookId = guser[@"id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MYUSERSTORE]) {
        NSLog(@"user %@",user);
        [self performSelector:@selector(loggedIn) withObject:nil afterDelay:2.0f];

    }
    else{
        
        NSDictionary *userDict = @{@"name":guser[@"name"],@"facebook":guser[@"id"]};
        
        [[NetworkHelper sharedInstance] getArrayFromPostURL:@"user/save" parmeters:@{@"user":userDict} completionHandler:^(id response, NSString *url, NSError *error){
            if (error == nil && response!=nil) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                
                NSLog(@"response string %@",responseDict);
                user = [[User alloc] init];
                user.userId = responseDict[@"user_id"];
                user.name = guser[@"name"];
                user.facebookId = guser[@"id"];
                NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    CustomTabbarController *obj=(CustomTabbarController *)[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
                    self.navigationController.navigationBarHidden=YES;
                    [self.navigationController pushViewController:obj animated:YES];
                });
                
            }
        }];

    }
    
    
    
}



- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    [self performSelector:@selector(loggedIn) withObject:nil afterDelay:2.0f];


}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    //self.statusLabel.text= @"You're not logged in!";
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
