//
//  NearbyViewController.m
//  spalor
//
//  Created by Manish on 13/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "NearbyViewController.h"
#import "MerchantListViewController.h"

@interface NearbyViewController (){
    NSString *searchText;
}

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self performSegueWithIdentifier:@"ShowMerchantList" sender:nil];
    
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //START THE ANIMATION HERE
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
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowMerchantList"]) {
        
        MerchantListViewController *controller = (MerchantListViewController *)segue.destinationViewController;
        controller.searchText  = searchText;
    }
}


@end
