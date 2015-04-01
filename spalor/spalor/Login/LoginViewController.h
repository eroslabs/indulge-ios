//
//  LoginViewController.h
//  spalor
//
//  Created by Manish on 05/02/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;

@interface LoginViewController : UIViewController<FBLoginViewDelegate,GPPSignInDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)login:(id)sender;
@end
