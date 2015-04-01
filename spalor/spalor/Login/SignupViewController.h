//
//  SignupViewController.h
//  spalor
//
//  Created by Manish on 09/02/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *profilebackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
-(IBAction)showImagePickerOptionsActionSheet:(id)sender;
@end
