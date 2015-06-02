//
//  ChangePasswordViewController.h
//  spalor
//
//  Created by Manish on 02/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ChangePasswordViewController : UIViewController
@property User *user;
@property (nonatomic, weak) IBOutlet UITextField *oldPassword;
@property (nonatomic, weak) IBOutlet UITextField *PasswordField1;
@property (nonatomic, weak) IBOutlet UITextField *PasswordField2;

@end
