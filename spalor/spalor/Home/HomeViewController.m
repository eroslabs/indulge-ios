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
#import <QuartzCore/QuartzCore.h>
#import "MerchantListViewController.h"
#import "LocationHelper.h"

@interface HomeViewController (){
    NSString *searchText;
    NSMutableArray *data;
    BOOL searching;
}
@end

@implementation HomeViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //[[NetworkHelper sharedInstance] formRequestwithemail:@"vikas@eroslabs.co"];
    searching = NO;
    data = [NSMutableArray new];
    [self setupRecomendedButttons];
    
    [self searchStateOn:NO];
    
    [[LocationHelper sharedInstance] startLocationManager];
    
    //@{@"s":@"abc",@"hs":@"1",@"gs":@"1",@"services":@[@"1",@"2",@"3",@"4",@"5"],@"pf":@"0",@"pt":@"2000",@"point":@[@"34.5,34.5"],@"pr":@{@"page":@"0",@"size":@""}}
    
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
        if (onState) {
            self.backgroundImageView.image = [UIImage imageNamed:@"Homepage-image1.png"];
        }
        else{
            self.backgroundImageView.image = [UIImage imageNamed:@"Homepage-image.png"];
        }
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
    NSInteger numOfRows = (searching)?data.count:10;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =  @"SuggestedCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (searching) {
        cell.textLabel.text = data[indexPath.row];
    }
    else{
        cell.textLabel.text = @"Suggested Search";
    }
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Regular" size:11.0f];

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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (searching) {
        searchText = cell.textLabel.text;
    }
    if (searchText.length > 0) {
        [self performSegueWithIdentifier:@"SHOWMERCHANTDETAIL" sender:nil];
    }

}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //START THE ANIMATION HERE
    [self searchStateOn:YES];
    textField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    if (textField.text.length>0) {
        searchText = textField.text;
        [self performSegueWithIdentifier:@"ShowMerchantList" sender:nil];
    }
    else{
        textField.text = @"Enter service, location , merchant";
        [self searchStateOn:NO];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(self.searchButton.hidden){
        [self searchStateOn:YES];
        
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (newString.length > 0) {
        [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/suggestMerchant" withParameters:@{@"s":newString} completionHandler:^(id response, NSString *url, NSError *error) {
            if (!error) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                
                NSLog(@"response string %@",responseDict);
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    searching = YES;
                    data = responseDict[@"result"];
                    [self.tableView reloadData];
 
                });
            }
            //return data;
            
        }];

    }
    else{
        searching = NO;
        [self.tableView reloadData];
    }
    
    return YES;
}

#pragma mark - User Actions

-(IBAction)search:(id)sender{
    [self searchStateOn:YES];
}

-(IBAction)goBackFromSearch:(id)sender{
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = @"Enter service, location , merchant";
    [self searchStateOn:NO];
}

#pragma mark - Segue 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowMerchantList"]) {
        
        MerchantListViewController *controller = (MerchantListViewController *)segue.destinationViewController;
        controller.searchText  = searchText;
    }
}


#pragma mark - AutoDelegate

-(void)didSelectText:(NSString *)text{
    //Perform segue with search text
}




@end

