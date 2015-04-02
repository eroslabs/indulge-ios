//
//  ForgotPasswordViewController.m
//  spalor
//
//  Created by Manish on 02/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "FormInputCell.h"
#import "UIImage+ImageEffects.h"

@implementation ForgotPasswordViewController

#pragma mark -

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)sendPasswordReset:(id)sender{
    [UIView animateWithDuration:1.5f animations:^{
        self.overlayView.alpha = 0.75;
        self.mailMessageView.alpha = 1;
        self.tableView.alpha = 0;
        self.sendButton.alpha = 0;
        self.goBackButton.alpha = 1;  
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.backgroundImageView.image = [self.backgroundImageView.image applyCustomEffectWithWhite:0.5 andAlpha:0.3];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.goBackButton.alpha = 0;
    self.overlayView.alpha = 0;
    self.mailMessageView.alpha = 0;
    self.tableView.alpha = 1;
    self.sendButton.alpha = 1;
}

#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 1;
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
    cell.cellInputTextField.placeholder = @"Enter your Email Address";
    
    cell.cellIconImageView.image = [UIImage imageNamed:@"registration-profile.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
