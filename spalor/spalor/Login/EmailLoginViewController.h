//
//  EmailLoginViewController.h
//  spalor
//
//  Created by Manish on 02/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailLoginViewController : UIViewController{
    NSString *userName;
    NSString *pass;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
-(IBAction)goBack:(id)sender;
@end
