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
    FeSpinnerTenDot *spinner;
    GPPSignIn *signIn;
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
    
    signIn = [GPPSignIn sharedInstance];
    
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin,
                       kGTLAuthScopePlusMe,
                       kGTLAuthScopePlusUserinfoEmail,
                       kGTLAuthScopePlusUserinfoProfile ];  // "https://www.googleapis.com/auth/plus.login" scope
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

#pragma mark - GPS SignIn Delegate

- (void)didDisconnectWithError:(NSError *)error{
    [self userLoginFailed];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    if (error) {
        //Show Error Alert
        DLog(@"Received error %@ and auth object %@",[error localizedDescription], auth);

    }
    else {
        spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
        [self.loaderContainerView addSubview:spinner];
        self.loaderContainerView.hidden = NO;
        [spinner show];
        
        DLog(@"GPS %@",signIn.userEmail);
        //[self refreshInterfaceBasedOnSignIn];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        // 3. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        //Handle Error
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            [self userLoginFailed];
                        });
                    } else {
                        
                        NSArray * userEmails = person.emails;
                        NSString * email = ((GTLPlusPersonEmailsItem *)[userEmails objectAtIndex:0]).value;

                        DLog(@"Email= %@", signIn.authentication.userEmail);
                        DLog(@"GoogleID=%@", person.identifier);
                        DLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        DLog(@"Gender=%@", person.gender);
                        
                        if (email.length == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to retrieve email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                                [self userLoginFailed];
                                return ;
                            });
                        }
                        
                        
                        User *user = [[User alloc] init];
                        user.name = [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName];
                        
                        user.gender = ([person.gender isEqualToString:@"male"])?@"0":@"1";;
                        
                        user.mail = email;
                        
                        user.googleId = person.identifier;
                        
                        
                        
                        NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                        [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[LoginHelper sharedInstance] userLoggedInwithFBUserObject:user];
                        });

                        
                        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:person.image.url]];
                        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                            
                            if (error == nil) {
                                
                                user.imageData = data;
                                NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                                [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                
                                
                            }
                        }];

                    }
                }];
    }
    
//    else{
//        DLog(@"Received auth object %@", auth);
//
//        [self performSelector:@selector(loggedIn) withObject:nil afterDelay:2.0f];
//
//    }
}



@end
