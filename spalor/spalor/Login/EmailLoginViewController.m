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

@implementation EmailLoginViewController
#pragma mark -

- (IBAction)signup:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AUTHENTICATED"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:obj animated:YES];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.backgroundImageView.image = [self.backgroundImageView.image applyCustomEffectWithWhite:0.5 andAlpha:0.3];
    
}


#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 2;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 93;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"formCell"];
    //cell.textLabel.text = @"Sample";
    if(indexPath.row == 0)
        cell.cellInputTextField.placeholder = @"Email";
    else
        cell.cellInputTextField.placeholder = @"Password";
    
    cell.cellIconImageView.image = [UIImage imageNamed:@"registration-profile.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
