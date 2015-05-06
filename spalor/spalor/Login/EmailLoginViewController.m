//
//  EmailLoginViewController.m
//  spalor
//
//  Created by Manish on 02/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "FormInputCell.h"
#import "UIImage+ImageEffects.h"
#import "NetworkHelper.h"
#import "CustomTabbarController.h"
#import "User.h"


@implementation EmailLoginViewController
#pragma mark -

- (IBAction)signup:(id)sender {


    //if (userName.length>0 && pass.length>0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"user/login" withParameters:@{@"userEmail":@"manish@eroslabs.co",@"passPhrase":@"12345"} completionHandler:^(id response, NSString *url, NSError *error){
            
            if (error == nil && response!=nil) {
                dispatch_async (dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

                    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"response Dict %@",responseDict);
                    NSDictionary *userDict = responseDict[@"user"];
                    if(userDict){
                        User *user = [[User alloc] init];
                        [user readFromDictionary:userDict];
                        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:MYUSERSTORE];

                    }
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AUTHENTICATED"];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
                    self.navigationController.navigationBarHidden=YES;
                    [self.navigationController pushViewController:obj animated:YES];
                });
                
                
            }
            else{
                dispatch_async (dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

                    UIAlertView *erroralert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [erroralert show];
                });
            }
        }];

   // }
    
/*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomTabbarController *obj=(CustomTabbarController *)[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:obj animated:YES];
 */
}


-(void)viewDidLoad{
    [super viewDidLoad];
    //self.backgroundImageView.image = [self.backgroundImageView.image applyCustomEffectWithWhite:0.5 andAlpha:0.3];
    self.loginButton.layer.cornerRadius = 4.0f;
    self.loginButton.clipsToBounds = YES;
}


-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numOfSections = 1;
    return numOfSections;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 2;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"formCell"];
    //cell.textLabel.text = @"Sample";
    if(indexPath.row == 0){
        cell.cellInputTextField.placeholder = @"USERNAME";
        cell.cellIconImageView.image = [UIImage imageNamed:@"registration-profile.png"];
        cell.cellInputTextField.returnKeyType = UIReturnKeyNext;
        cell.cellInputTextField.tag = -1;
        cell.cellInputTextField.delegate = self;

    }
    else{
        cell.cellInputTextField.placeholder = @"PASSWORD";
        cell.cellIconImageView.image = [UIImage imageNamed:@"registration-mobile.png"];
        cell.cellInputTextField.returnKeyType = UIReturnKeyGo;
        cell.cellInputTextField.tag = -2;

        cell.cellInputTextField.delegate = self;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == -1) {
        userName = textField.text;
        [textField resignFirstResponder];
    }
    else if(textField.tag == -2){
        pass = textField.text;
        [textField resignFirstResponder];
        [self signup:nil];
    }
    return YES;
}

@end
