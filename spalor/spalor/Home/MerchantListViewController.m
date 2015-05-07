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
    NSMutableDictionary *localFilterDict;
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

    localFilterDict = [[NSUserDefaults standardUserDefaults] objectForKey:MYLOCALFILTERSTORE];
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
    
    
    NSDictionary *filterDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"];
    
    
    NSLog(@"filter Dict %@",filterDict);
    
    NSMutableDictionary *paramDict = [NSMutableDictionary new];
    
    [paramDict addEntriesFromDictionary:@{@"s":self.searchText}];
    [paramDict addEntriesFromDictionary:filterDict];
    if(myLocation){
        [paramDict addEntriesFromDictionary:@{@"lat":[NSString stringWithFormat:@"%f",myLocation.coordinate.latitude],@"lon":[NSString stringWithFormat:@"%f",myLocation.coordinate.longitude]}];
    }
    
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
        
        BOOL check = [self isMerchantPassedFromLocalFilter:merchant];
        NSLog(@"merchant %@",merchant.name);
        
        if (check) {
            [merchantArray addObject:merchant];
        }

    }
    
    if (merchantArray.count>0) {
        // Now Apply sorting
        
        BOOL ascendingDistance = NO;
        BOOL ascendingPrice = NO;

        if ([localFilterDict[@"distance"] isEqual:@(1)]) {
            //Ascending
            ascendingDistance = YES;
        }
        
        if ([localFilterDict[@"price"] isEqual:@(1)]) {
            ascendingPrice = YES;
        }
        
        NSSortDescriptor *distanceSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromCurrentLocation"
                                                                                  ascending:ascendingDistance
                                                                                   selector:@selector(localizedStandardCompare:)];

        NSSortDescriptor *priceSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"luxuryRating"
                                                                                 ascending:ascendingPrice
                                                                                  selector:@selector(localizedStandardCompare:)];

        merchantArray = [merchantArray sortedArrayUsingDescriptors:@[distanceSortDescriptor,priceSortDescriptor]];
    }
    return merchantArray;
}

-(int)currentWeekday{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    int weekday = [comps weekday];
    return weekday;
}

-(BOOL)isMerchantOpen:(Schedule *)schedule{
    NSArray *openingArray = [schedule.openingTime componentsSeparatedByString:@":"];
    NSString *openingHr = openingArray[0];
    NSString *openingMin = openingArray[1];
    
    NSArray *closingArray = [schedule.closingTime componentsSeparatedByString:@":"];
    NSString *closingHr = closingArray[1];
    NSString *closingMin = closingArray[1];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDateComponents *dateComps = [gregorianCal components: (NSCalendarUnitHour | NSCalendarUnitMinute)
                                                  fromDate: [NSDate date]];
    // Then use it
    NSInteger currentMin = [dateComps minute];
    NSInteger currentHr = [dateComps hour];
    
    if (currentHr > closingHr.integerValue) {
        return NO;
    }
    if (currentHr < openingHr.integerValue) {
        return NO;
    }
    if (currentHr == closingHr.integerValue && currentMin > closingMin.integerValue) {
        return NO;
    }
    if (currentHr == openingHr.integerValue && currentMin < openingMin.integerValue) {
        return NO;
    }
    
    return YES;
}

-(BOOL)isMerchantPassedFromLocalFilter:(Merchant *)merchant{
    
    for (NSString *key in [localFilterDict allKeys]) {
        if([key isEqualToString:@"opennow"]){
            if ([localFilterDict[key] isEqual:@(1)]) {
                if (![merchant.weekdaysArray containsObject:[NSString stringWithFormat:@"%d",[self currentWeekday]]]) {
                    //Check if time falls between opening and closing
                   
                    
                    
                    return NO;
                }
            }
            if ([localFilterDict[key] isEqual:@(2)]) {
                if ([merchant.weekdaysArray containsObject:[NSString stringWithFormat:@"%d",[self currentWeekday]]]) {
                    return NO;
                }
            }
            
        }
        if([key isEqualToString:@"3.5+"]){
            if (merchant.rating.floatValue<3.5) {
                return NO;
            }
        }
        if([key isEqualToString:@"gender"]){
            if ([localFilterDict[key] isEqualToString:@"male"]) {
                if (![merchant.genderSupport isEqualToString:@"1"]) {
                    return NO;
                }
            }
            else if ([localFilterDict[key] isEqualToString:@"female"]) {
                if (![merchant.genderSupport isEqualToString:@"0"]) {
                    return NO;
                }
            }
            else{
                if (![merchant.genderSupport isEqualToString:@"2"]) {
                    return NO;
                }
            }
        }
        if ([key isEqualToString:@"athome"]) {
            if ([localFilterDict[key] isEqual:@(1)]) {
                if ([merchant.homeService isEqualToString:@"0"]) {
                    return NO;
                }
            }
            if ([localFilterDict[key] isEqual:@(0)]) {
                if ([merchant.homeService isEqualToString:@"1"]) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
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
    if(merchant.distanceFromCurrentLocation.floatValue == 0.0){
        cell.distanceLabel.hidden = YES;
        cell.distancebackgroundImageView.hidden = YES;
        
    }
    else{
        cell.distanceLabel.text = merchant.distanceFromCurrentLocation;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedMerchant = arrayOfMerchants[indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    
}


#pragma mark - User Actions

-(IBAction)changeLocalFilter:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    senderButton.selected = !senderButton.selected;
    
    BOOL selected = senderButton.selected;
    
    switch (senderButton.tag) {
        case 1:
            [localFilterDict addEntriesFromDictionary:@{@"opennow":@(selected)}];
            break;
        case 2:
            [localFilterDict addEntriesFromDictionary:@{@"3.5+":@(selected)}];
            break;
        case 3:
            [localFilterDict addEntriesFromDictionary:@{@"distance":@(selected)}];
            break;
        case 4:
            [localFilterDict addEntriesFromDictionary:@{@"price":@(selected)}];
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:localFilterDict forKey:MYLOCALFILTERSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *newMerchantArray = [NSMutableArray new];
    
    for (Merchant *merchant in arrayOfMerchants) {
        BOOL check = [self isMerchantPassedFromLocalFilter:merchant];
        
        if (check) {
            [newMerchantArray addObject:merchant];
        }
    }
    
    arrayOfMerchants = newMerchantArray;
    [self.tableview reloadData];
}


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
