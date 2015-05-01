//
//  DealsViewController.m
//  spalor
//
//  Created by Manish on 24/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealsViewController.h"
#import "NetworkHelper.h"
#import "DealListCell.h"
#import "DealDetailsViewController.h"
#import "Deal.h"
#import "FeSpinnerTenDot.h"
#import "SuggestedTableViewCell.h"
#import "LocationHelper.h"

@interface DealsViewController (){
    NSArray *arrayOfDeals;
    Deal *selectedDeal;
    FeSpinnerTenDot *spinner;
    NSString *searchText;
    BOOL searching;
    NSArray *data;
}
@end

@implementation DealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchText = @"";
    spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
    [self.loaderContainerView addSubview:spinner];
    self.loaderContainerView.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    searching = NO;
    if (arrayOfDeals.count == 0) {
        [spinner showWhileExecutingSelector:@selector(searchForNewDeals) onTarget:self withObject:nil];
    }
    
}

-(void)searchForNewDeals{
    
    if(![[LocationHelper sharedInstance] checkPermission]){
        //Show location manager not enabled screen
        UIAlertView *noLocationAlert = [[UIAlertView alloc] initWithTitle:@"Location Disabled!" message:@"Please enable location to get the restults" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noLocationAlert show];
        [spinner dismiss];
        self.loaderContainerView.hidden = YES;
        return;
    }
    
    CLLocation *myLocation = [[LocationHelper sharedInstance] getCurrentLocation];
    
    if(!myLocation){
        [self performSelector:@selector(searchForNewDeals) withObject:nil afterDelay:2.0f];
        return;
    }
    
    NSDictionary *filterDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"];
    
    
    NSLog(@"filter Dict %@",filterDict);
    
    NSMutableDictionary *paramDict = [NSMutableDictionary new];
    
    [paramDict addEntriesFromDictionary:@{@"s":searchText}];
    [paramDict addEntriesFromDictionary:filterDict];
    //[paramDict addEntriesFromDictionary:@{@"lat":[NSString stringWithFormat:@"%f",myLocation.coordinate.latitude],@"lon":[NSString stringWithFormat:@"%f",myLocation.coordinate.longitude]}];

    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/searchDeals" withParameters:paramDict completionHandler:^(id response, NSString *url, NSError *error){
        
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            
            
            
            if (responseDict) {
                arrayOfDeals = [self captureAllMerchantsFromResponseDict:responseDict];
                if (arrayOfDeals.count>0) {
                   
                    //Only put if there was no error
                    [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"DealResponse"];

                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner dismiss];
                searching = NO;
                self.loaderContainerView.hidden = YES;
                [self.tableview reloadData];
            });
            
        }
        else{
            NSLog(@"error %@",[error localizedDescription]);
        }
    }];

}

-(void)pickUpLocallyStoredMerchantResponse{
    NSData *response = [[NSUserDefaults standardUserDefaults] objectForKey:@"DealResponse"];
    
    NSError *error = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"response string %@",responseDict);
    

    
    if(error) {  //Handle error
        NSLog(@"error %@",[error localizedDescription]);
        
    }
    else{
        NSLog(@"response string %@",responseDict);
        
        if (responseDict) {
            arrayOfDeals = [self captureAllMerchantsFromResponseDict:responseDict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner dismiss];
            self.loaderContainerView.hidden = YES;
            [self.tableview reloadData];
        });
    }
    
}



-(NSArray *)captureAllMerchantsFromResponseDict:(NSDictionary *)dictionary{
    
    NSArray *resultArray = dictionary[@"result"];
    NSMutableArray *dealArray = [NSMutableArray new];
    
    for (NSDictionary *dealDict in resultArray) {
        
        Deal *deal = [[Deal alloc] init];
        [deal readFromDictionary:dealDict];
        
        NSLog(@"deal %@",deal.name);
        
        [dealArray addObject:deal];
        
    }
    
    return dealArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Datasource and Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = (searching)?data.count:arrayOfDeals.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (searching)?40:170;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searching) {
        NSString *identifier =  @"SuggestedCellIdentifier";
        
        SuggestedTableViewCell *cell = (SuggestedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        cell.searchLabel.text = data[indexPath.row];
        return cell;

    }
    else{
        NSString *identifier =  @"DealCellIdentifier";
        Deal *deal = arrayOfDeals[indexPath.row];
        DealListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
        
        cell.nameLabel.text = deal.name;
        cell.addressLabel.text = deal.address;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:deal.geo.lat.floatValue longitude:deal.geo.lon.floatValue];
        CGFloat distance = [[LocationHelper sharedInstance] distanceInmeteresFrom:location];
        if(distance == -1.0){
            cell.distanceLabel.hidden = YES;
            cell.distanceBackgroundImageView.hidden = YES;
            
        }
        else{
            cell.distanceLabel.text = [NSString stringWithFormat:@"%f",distance];
            cell.distanceBackgroundImageView.hidden = NO;
        }
        cell.averageRating.text = deal.rating;
        cell.amountOffLabel.text = (deal.percentOff)?deal.percentOff:deal.amountOff;
        return cell;
    }
    
    return nil;
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searching) {
        SuggestedTableViewCell *cell = (SuggestedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        searchText = [cell.searchLabel.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        [spinner showWhileExecutingSelector:@selector(searchForNewDeals) onTarget:self withObject:nil];
    }
    else{
        selectedDeal = arrayOfDeals[indexPath.row];
        [self performSegueWithIdentifier:@"showDealDetails" sender:self];
    }
    
}

#pragma mark - User Actions
-(IBAction)showFilterScreen:(id)sender{
    [self performSegueWithIdentifier:@"showFilter" sender:self];

}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDealDetails"]) {
        
        DealDetailsViewController *controller = (DealDetailsViewController *)segue.destinationViewController;
        controller.deal  = selectedDeal;
    }
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
        searchText = [textField.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    }
    else{
        textField.text = @"Enter service, location , merchant";
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length > 0) {
        searching = YES;
        [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/suggestMerchant" withParameters:@{@"s":newString} completionHandler:^(id response, NSString *url, NSError *error) {
            if (!error) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                
                NSLog(@"response string %@",responseDict);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    searching = YES;
                    data = responseDict[@"result"];
                    self.tableview.backgroundColor = [UIColor whiteColor];
                    [self.tableview reloadData];
                    
                });
            }
            //return data;
            
        }];
        
    }
    else{
        searching = NO;
        self.tableview.backgroundColor = [UIColor clearColor];
        [self.tableview reloadData];
    }
    
    return YES;
}



@end
