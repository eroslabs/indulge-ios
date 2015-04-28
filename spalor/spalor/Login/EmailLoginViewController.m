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

@implementation EmailLoginViewController
#pragma mark -

- (IBAction)signup:(id)sender {

/*
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"user/login" withParameters:@{@"userEmail":@"manish@eroslabs.co",@"passPhrase":@"12345"} completionHandler:^(id response, NSString *url, NSError *error){
        
        if (error == nil && response!=nil) {
            dispatch_async (dispatch_get_main_queue(), ^{
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"response Dict %@",responseDict);
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AUTHENTICATED"];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
                self.navigationController.navigationBarHidden=YES;
                [self.navigationController pushViewController:obj animated:YES];
            });

            
        }
    }];
 
 */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:obj animated:YES];
    
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

    }
    else{
        cell.cellInputTextField.placeholder = @"PASSWORD";
        cell.cellIconImageView.image = [UIImage imageNamed:@"registration-mobile.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
