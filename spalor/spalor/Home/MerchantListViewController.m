//
//  MerchantListViewController.m
//  spalor
//
//  Created by Manish on 13/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantListViewController.h"
#import "Merchant.h"
#import "NetworkHelper.h"
#import "MerchantListCell.h"
#import "FeSpinnerTenDot.h"
#import "UIColor+flat.h"
#import "LocationHelper.h"
#import "MerchantDetailViewController.h"

@interface MerchantListViewController (){
    NSArray *arrayOfMerchants;
    FeSpinnerTenDot *spinner;
    Merchant *selectedMerchant;
}

@end

@implementation MerchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
    [self.loaderContainerView addSubview:spinner];
    self.loaderContainerView.hidden = NO;
    [spinner showWhileExecutingSelector:@selector(pickUpLocallyStoredMerchantResponse) onTarget:self withObject:nil];

}

-(void)searchForNewMerchants{
    
    //Sort - Rating Distance popularity price
    /*
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/loadCategories" withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error){
        
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
        }
    }];
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/loadSearches" withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error){
        
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
        }
    }];
     */
    
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
        [self performSelector:@selector(searchForNewMerchants) withObject:nil afterDelay:2.0f];
    }
    
    NSDictionary *filterDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"];
    
    
    NSLog(@"filter Dict %@",filterDict);
    
    NSMutableDictionary *paramDict = [NSMutableDictionary new];
    
    [paramDict addEntriesFromDictionary:@{@"s":self.searchText}];
    //[paramDict addEntriesFromDictionary:filterDict];
    //[paramDict addEntriesFromDictionary:@{@"lat":[NSString stringWithFormat:@"%f",myLocation.coordinate.latitude],@"lon":[NSString stringWithFormat:@"%f",myLocation.coordinate.longitude]}];
    
    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/searchMerchant" withParameters:paramDict  completionHandler:^(id response, NSString *url, NSError *error){
        
            if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
                
            if (responseDict) {
                arrayOfMerchants = [self captureAllMerchantsFromResponseDict:responseDict];
                if (arrayOfMerchants.count>0) {
                    
                    //Only put if there was no error
                    [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"MerchantResponse"];
                    
                }
            }
            
            NSLog(@"array of merchants %@",arrayOfMerchants);
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner dismiss];
                    self.totalCountLabel.text = [NSString stringWithFormat:@"%lu Items",(unsigned long)arrayOfMerchants.count];
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
    NSData *response = [[NSUserDefaults standardUserDefaults] objectForKey:@"MerchantResponse"];
    
    NSError *error = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"response string %@",responseDict);
    
    if(error) {  //Handle error
        NSLog(@"error %@",[error localizedDescription]);
        
    }
    else{
        NSLog(@"response string %@",responseDict);
        
        if (responseDict) {
            arrayOfMerchants = [self captureAllMerchantsFromResponseDict:responseDict];
        }
        
        NSLog(@"array of merchants %@",arrayOfMerchants);
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner dismiss];
            self.totalCountLabel.text = [NSString stringWithFormat:@"%lu Items",(unsigned long)arrayOfMerchants.count];
            self.loaderContainerView.hidden = YES;
            [self.tableview reloadData];
        });
    }

}

-(NSArray *)captureAllMerchantsFromResponseDict:(NSDictionary *)dictionary{
   
    NSArray *resultArray = dictionary[@"result"];
    NSMutableArray *merchantArray = [NSMutableArray new];
    
    for (NSDictionary *merchantDict in resultArray) {
        
        Merchant *merchant = [[Merchant alloc] init];
        [merchant readFromDictionary:merchantDict];
        
        NSLog(@"merchant %@",merchant.name);
        
        [merchantArray addObject:merchant];

    }
    
    return merchantArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Datasource and Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = arrayOfMerchants.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =  @"MerchantIdentifier";
    Merchant *merchant = arrayOfMerchants[indexPath.row];
    MerchantListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.nameLabel.text = merchant.name;
    cell.addressLabel.text = (merchant.address)?merchant.address:@"Sample Address";
    cell.averageRating.text = merchant.rating;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:merchant.geo.lat.floatValue longitude:merchant.geo.lon.floatValue];
    CGFloat distance = [[LocationHelper sharedInstance] distanceInmeteresFrom:location];
    if(distance == -1.0){
        cell.distanceLabel.hidden = YES;
        cell.distancebackgroundImageView.hidden = YES;
        
    }
    else{
        cell.distanceLabel.text = [NSString stringWithFormat:@"%f",distance];
        cell.distancebackgroundImageView.hidden = NO;
    }
    cell.priceRangeImageView.image = [UIImage imageNamed:@"merchant-rupee4.png"];
    cell.backgroundImageView.image = [UIImage imageNamed:@"image.png"];
    cell.distancebackgroundImageView.image = [UIImage imageNamed:@"merchant-location.png"];
    [cell.callButton setImage:[UIImage imageNamed:@"merchant-listing-call.png"] forState:UIControlStateNormal];
    [cell.shareButton setImage:[UIImage imageNamed:@"merchant-share.png"] forState:UIControlStateNormal];
    [cell.favoriteButton setImage:[UIImage imageNamed:@"merchant-listing-favourite.png"] forState:UIControlStateNormal];
    [cell.dealsButton setImage:[UIImage imageNamed:@"merchant-listing-deal.png"] forState:UIControlStateNormal];

    cell.serviceCategorybackgroundImageView.image = [UIImage imageNamed:@"merchant-categories-bar.png"];
    
    cell.serviceCategoryImageView1.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView2.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView3.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView4.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView5.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView6.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView7.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView8.image = [UIImage imageNamed:@"merchant-massage.png"];
    cell.serviceCategoryImageView9.image = [UIImage imageNamed:@"merchant-massage.png"];

    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedMerchant = arrayOfMerchants[indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    
}


#pragma mark - User Actions

-(IBAction)goBackToSearch:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        MerchantDetailViewController *controller = (MerchantDetailViewController *)segue.destinationViewController;
        controller.merchant = selectedMerchant;
    }
}

@end
