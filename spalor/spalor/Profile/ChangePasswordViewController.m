//
//  ChangePasswordViewController.m
//  spalor
//
//  Created by Manish on 02/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NetworkHelper.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submit:(id)sender{
    
    if ([self.PasswordField1.text  isEqualToString:self.PasswordField2.text] && self.PasswordField1.text.length>0) {
        [[NetworkHelper sharedInstance] getArrayFromPostURL:@"user/changePassword" parmeters:@{@"userEmail":self.user.mail,@"oldPassphrase":self.oldPassword.text,@"passphrase":self.PasswordField1.text} completionHandler:^(id response, NSString *url, NSError *error){
            if (!error && response!=nil) {
                //Successfully changed
            }
        }];
        

    }
    
}

@end
