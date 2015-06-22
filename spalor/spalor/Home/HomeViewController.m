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
#import "SuggestedTableViewCell.h"

@interface HomeViewController (){
    NSString *searchText;
    NSMutableArray *data;
    NSMutableDictionary *localFilterDict;
    BOOL searching;
}
@end

@implementation HomeViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setButtonsFromLocalFilters];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //[[NetworkHelper sharedInstance] formRequestwithemail:@"vikas@eroslabs.co"];
    searching = NO;
    data = [NSMutableArray new];
    [self setupRecomendedButttons];
    
    [self searchStateOn:NO];

    self.dealImageView1.layer.cornerRadius = 10.0f;
    self.dealImageView2.layer.cornerRadius = 10.0f;
    self.dealImageView3.layer.cornerRadius = 10.0f;
    self.dealImageView4.layer.cornerRadius = 10.0f;
    self.dealImageView1.clipsToBounds = YES;
    self.dealImageView2.clipsToBounds = YES;
    self.dealImageView3.clipsToBounds = YES;
    self.dealImageView4.clipsToBounds = YES;

    //@{@"s":@"abc",@"hs":@"1",@"gs":@"1",@"services":@[@"1",@"2",@"3",@"4",@"5"],@"pf":@"0",@"pt":@"2000",@"point":@[@"34.5,34.5"],@"pr":@{@"page":@"0",@"size":@""}}
    localFilterDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MYLOCALFILTERSTORE]];
    [self setButtonsFromLocalFilters];

}

-(void)setButtonsFromLocalFilters{
    
    if ([localFilterDict[@"athome"] isEqual:@(1)]) {
        self.filterButton2.selected = YES;
    }
    else{
        self.filterButton2.selected = NO;
    }
    if([localFilterDict[@"opennow"] isEqual:@(1)]){
        self.filterButton1.selected = YES;
    }
    else{
        self.filterButton1.selected = NO;
    }
    if([localFilterDict[@"gender"] isEqual:@"male"]){
        self.filterButton3.selected = YES;
    }
    else{
        self.filterButton3.selected = NO;
    }
    if([localFilterDict[@"gender"] isEqual:@"female"]){
        self.filterButton4.selected = YES;
    }
    else{
        self.filterButton4.selected = NO;
    }
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
        
        self.filterButton1.alpha = onState;
        self.filterButton2.alpha = onState;
        self.filterButton3.alpha = onState;
        self.filterButton4.alpha = onState;

        [self setButtonsFromLocalFilters];
        
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
    
    SuggestedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (searching) {
        cell.searchLabel.text = data[indexPath.row];
    }
    else{
        cell.searchLabel.text = @"Suggested Search";
    }
    cell.searchLabel.font = [UIFont fontWithName:@"Avenir Next Regular" size:11.0f];

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
    SuggestedTableViewCell *cell = (SuggestedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (searching) {
        searchText = cell.searchLabel.text;
    }
    if (searchText.length > 0) {
        [self performSegueWithIdentifier:@"ShowMerchantList" sender:nil];
    }

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    //logic here
    [self.searchTextField resignFirstResponder];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //START THE ANIMATION HERE
    [self searchStateOn:YES];
    if ([textField.text isEqualToString:@"Enter service, location , merchant"]) {
        textField.text = @"";
    }
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

-(IBAction)changeLocalFilter:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    senderButton.selected = !senderButton.selected;
    
    BOOL selected = senderButton.selected;
    NSMutableDictionary *filterDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"]];

    NSString * defaultbooleanStringForHomeService =  @"0";
    [filterDict addEntriesFromDictionary:@{@"hs":defaultbooleanStringForHomeService}];


    switch (senderButton.tag) {
        case 1:
            [localFilterDict addEntriesFromDictionary:@{@"opennow":@(selected)}];
            break;
        case 2:{
            NSString * booleanString = (selected) ? @"1" : @"0";
            [localFilterDict addEntriesFromDictionary:@{@"athome":@(selected)}];
            [filterDict addEntriesFromDictionary:@{@"hs":booleanString}];
            break;
        }
        case 3:{
            [localFilterDict addEntriesFromDictionary:@{@"gender":@"male"}];
            [filterDict addEntriesFromDictionary:@{@"gs":@"0"}];

            break;
        }
        case 4:{
            [localFilterDict addEntriesFromDictionary:@{@"gender":@"female"}];
            [filterDict addEntriesFromDictionary:@{@"gs":@"1"}];

            break;
        }
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:filterDict forKey:@"filterDict"];
    [[NSUserDefaults standardUserDefaults] setObject:localFilterDict forKey:MYLOCALFILTERSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



-(IBAction)search:(id)sender{
    [self searchStateOn:YES];
}

-(IBAction)goBackFromSearch:(id)sender{
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = @"Enter service, location , merchant";
    [self searchStateOn:NO];
}

-(IBAction)showSearchWithKeyWord:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    if ([senderButton isEqual:self.recommededButton1]) {
        searchText = @"Hair";

    }
    if ([senderButton isEqual:self.recommededButton2]) {
        searchText = @"Salon";
        
    }
    if ([senderButton isEqual:self.recommededButton3]) {
        searchText = @"Spa";
        
    }
    if ([senderButton isEqual:self.recommededButton4]) {
        searchText = @"Message";
        
    }
    if ([senderButton isEqual:self.recommededButton5]) {
        searchText = @"Makeup";
        
    }
    
    self.searchTextField.text = searchText;
    [self performSegueWithIdentifier:@"ShowMerchantList" sender:nil];


}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowMerchantList"]) {
        
        MerchantListViewController *controller = (MerchantListViewController *)segue.destinationViewController;
        controller.searchText  = [searchText stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    }
}


#pragma mark - AutoDelegate

-(void)didSelectText:(NSString *)text{
    //Perform segue with search text
}




@end

