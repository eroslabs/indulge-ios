//
//  HomeViewController.m
//  spalor
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "HomeViewController.h"
#import "NetworkHelper.h"
#import "UIImage+ImageEffects.h"

@interface HomeViewController ()
@end

@implementation HomeViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //[[NetworkHelper sharedInstance] formRequestwithemail:@"vikas@eroslabs.co"];
    [self setupRecomendedButttons];
    
    [self searchStateOn:NO];
    
    //@{@"s":@"abc",@"hs":@"1",@"gs":@"1",@"services":@[@"1",@"2",@"3",@"4",@"5"],@"pf":@"0",@"pt":@"2000",@"point":@[@"34.5,34.5"],@"pr":@{@"page":@"0",@"size":@""}}
    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"user/getMerchant" withParameters:@{@"s":@"abc",@"hs":@"1",@"services":@"1,2,3,4,5",@"point":@"34.5,34.5",@"page":@"0,distance,asc"} completionHandler:^(id response, NSString *url, NSError *error){
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
        }
        else{
            NSLog(@"error %@",[error localizedDescription]);
        }
    }];
}

-(void)searchStateOn:(BOOL)onState{
    
    [UIView animateWithDuration:0.3f animations:^{
        self.locationIconImageView.alpha = !onState;
        self.locationLabel.alpha = !onState;
        self.headerTitleLabel.alpha = !onState;
        self.bottomView.alpha = !onState;
        self.recommededButton1.alpha = !onState;
        self.recommededButton2.alpha = !onState;
        self.recommededButton3.alpha = !onState;
        self.recommededButton4.alpha = !onState;
        self.recommededButton5.alpha = !onState;
        
        self.goBackFromSearchButton.alpha = onState;
        self.locationSearchBackgroundImageView.alpha = onState;
        self.locationSearchTextField.alpha = onState;
        self.tableView.alpha = onState;

    }];
    
    
}



-(void)setupRecomendedButttons{
    self.recommededButton1.layer.cornerRadius = 4.0f;
    self.recommededButton2.layer.cornerRadius = 4.0f;
    self.recommededButton3.layer.cornerRadius = 4.0f;
    self.recommededButton4.layer.cornerRadius = 4.0f;
    self.recommededButton5.layer.cornerRadius = 4.0f;

    self.recommededButton1.clipsToBounds = YES;
    self.recommededButton2.clipsToBounds = YES;
    self.recommededButton3.clipsToBounds = YES;
    self.recommededButton4.clipsToBounds = YES;
    self.recommededButton5.clipsToBounds = YES;
    
    CGRect oldFrame = self.searchButton.frame;
    CGRect newFrame = oldFrame;
    newFrame.origin.x = 14;
    newFrame.origin.y = self.filterButton.frame.origin.y;
    self.searchButton.frame = newFrame;
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 10;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =  @"SuggestedCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 0, tableView.frame.size.width, 20);
    myLabel.font = [UIFont fontWithName:@"Avenir Next Demi Bold" size:12.0f];
    myLabel.text = @"Suggested Searches";
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.9254f green:0.9254f blue:0.9254f alpha:1.0f];
    [headerView addSubview:myLabel];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 20.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"SHOWMERCHANTDETAIL" sender:nil];

}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //START THE ANIMATION HERE
    [self searchStateOn:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    if (textField.text.length>0) {
        [self performSegueWithIdentifier:@"SHOWMERCHANTDETAIL" sender:nil];
    }
    else{
        [self searchStateOn:NO];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(self.searchButton.hidden){
        [self searchStateOn:YES];
    }
    
    return YES;
}

#pragma mark - User Actions

-(IBAction)search:(id)sender{
    [self searchStateOn:YES];
}

-(IBAction)goBackFromSearch:(id)sender{
    [self.searchTextField resignFirstResponder];
    [self searchStateOn:NO];
}


@end

