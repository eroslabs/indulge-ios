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
#import "User.h"

@interface DealsViewController (){
    NSArray *arrayOfDeals;
    Deal *selectedDeal;
    FeSpinnerTenDot *spinner;
    NSString *searchText;
    BOOL searching;
    NSArray *data;
    NSMutableDictionary *localFilterDict;
    NSMutableArray *myDealsArray;
    UIRefreshControl *refresh;
    BOOL _isSearching;
}
@end

@implementation DealsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchText = @"";
    myDealsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:MYDEALSSTORE]];
    
    _isSearching = NO;

    localFilterDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MYLOCALFILTERSTORE]];
    
    DLog(@"local filter %@",localFilterDict);
    [self setButtonsFromLocalFilters];
    
    refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh Deals"];
    [refresh addTarget:self action:@selector(refreshCalled) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refresh];
    

}


-(void)loadNewDealsWithSpinner{
    spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
    self.loaderContainerView.hidden = NO;
    [self.loaderContainerView addSubview:spinner];
    [spinner showWhileExecutingSelector:@selector(searchForNewDeals) onTarget:self withObject:nil];

}

-(void)refreshCalled{
    DLog(@"refresh");
    [self loadNewDealsWithSpinner];
}


-(void)setButtonsFromLocalFilters{
    
    if ([localFilterDict[@"opennow"] isEqual:@(1)]) {
        self.localFilterButton1.selected = YES;
    }
    else{
        self.localFilterButton1.selected = NO;
    }
    if([localFilterDict[@"3.5+"] isEqual:@(1)]){
        self.localFilterButton2.selected = YES;
    }
    else{
        self.localFilterButton2.selected = NO;
    }
    if([localFilterDict[@"distance"] isEqual:@(1)]){
        self.localFilterButton3.selected = YES;
    }
    else{
        self.localFilterButton3.selected = NO;
    }
    if([localFilterDict[@"price"] isEqual:@(1)]){
        self.localFilterButton4.selected = YES;
    }
    else{
        self.localFilterButton4.selected = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    searchText = @"";
    searching = NO;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"refreshFilterChanged"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"refreshFilterChanged"];
        [self loadNewDealsWithSpinner];
    }
    else if (arrayOfDeals.count == 0) {
        [self loadNewDealsWithSpinner];


    }
    
}

-(void)searchForNewDeals{
    
    if(_isSearching){
        return;
    }
    
    _isSearching = YES;
    
    if(![[LocationHelper sharedInstance] checkPermission]){
        //Show location manager not enabled screen
        UIAlertView *noLocationAlert = [[UIAlertView alloc] initWithTitle:@"Location Disabled!" message:@"Please enable location to get the restults" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noLocationAlert show];
        [spinner dismiss];
        [refresh endRefreshing];
        self.loaderContainerView.hidden = YES;
        _isSearching = NO;
        return;
    }
    
    CLLocation *myLocation = [[LocationHelper sharedInstance] getCurrentLocation];
    
    NSDictionary *filterDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"filterDict"];

    DLog(@"filter Dict %@",filterDict);
    
    NSMutableDictionary *paramDict = [NSMutableDictionary new];
    
    [paramDict addEntriesFromDictionary:@{@"s":searchText}];
    [paramDict addEntriesFromDictionary:filterDict];
    if(myLocation){
        [paramDict addEntriesFromDictionary:@{@"lat":[NSString stringWithFormat:@"%f",myLocation.coordinate.latitude],@"lon":[NSString stringWithFormat:@"%f",myLocation.coordinate.longitude]}];
    }

    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/searchDeals" withParameters:paramDict completionHandler:^(id response, NSString *url, NSError *error){
        
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            DLog(@"response string %@",responseDict);
            
            
            
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
                _isSearching = NO;
                [refresh endRefreshing];
                


            });
            
        }
        else{
            DLog(@"error %@",[error localizedDescription]);
            [spinner dismiss];
            searching = NO;
            self.loaderContainerView.hidden = YES;
            _isSearching = NO;

        }
    }];

}

-(void)pickUpLocallyStoredMerchantResponse{
    NSData *response = [[NSUserDefaults standardUserDefaults] objectForKey:@"DealResponse"];
    
    NSError *error = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    DLog(@"response string %@",responseDict);
    

    
    if(error) {  //Handle error
        DLog(@"error %@",[error localizedDescription]);
        
    }
    else{
        DLog(@"response string %@",responseDict);
        
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
        
        BOOL check = [self isDealPassedFromLocalFilter:deal];
        
        if (check) {
            [dealArray addObject:deal];
        }
        
    }
    
    if (dealArray.count>0) {
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
        
        dealArray = [dealArray sortedArrayUsingDescriptors:@[distanceSortDescriptor,priceSortDescriptor]];
    }
    
    return dealArray;
}

-(int)currentWeekday{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    DLog(@"current week day %d",weekday);
    
    return weekday;
}


-(BOOL)isMerchantOpen:(Schedule *)schedule{
    NSArray *openingArray = [schedule.openingTime componentsSeparatedByString:@":"];
    NSString *openingHr = openingArray[0];
    NSString *openingMin = openingArray[1];
    
    NSArray *closingArray = [schedule.closingTime componentsSeparatedByString:@":"];
    NSString *closingHr = closingArray[0];
    NSString *closingMin = closingArray[1];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDateComponents *dateComps = [gregorianCal components: (NSCalendarUnitHour | NSCalendarUnitMinute)
                                                  fromDate: [NSDate date]];
    // Then use it
    NSInteger currentMin = [dateComps minute];
    NSInteger currentHr = [dateComps hour];
    NSInteger currentHrForClosingCheck = (currentHr>12)?(currentHr-12):currentHr;

    DLog(@"current hr %d current min %d closinghr %d closing min %d openinghr %d openingmin %d",currentHr,currentMin,closingHr.integerValue,closingMin.integerValue,openingHr.integerValue,openingMin.integerValue);
    
    if (currentHrForClosingCheck > closingHr.integerValue) {
        return NO;
    }
    if (currentHr < openingHr.integerValue) {
        return NO;
    }
    if (currentHrForClosingCheck == closingHr.integerValue && currentMin > closingMin.integerValue) {
        return NO;
    }
    if (currentHr == openingHr.integerValue && currentMin < openingMin.integerValue) {
        return NO;
    }
    
    return YES;
}

-(BOOL)isDealPassedFromLocalFilter:(Deal *)deal{
    
    for (NSString *key in [localFilterDict allKeys]) {
        DLog(@"key %@ %@",key,localFilterDict[key]);
        
        if ([key isEqualToString:@"opennow"]) {
            if ([localFilterDict[key] isEqual:@(1)]) {
                if ([deal.weekdaysArray containsObject:[NSString stringWithFormat:@"%d",[self currentWeekday]]]) {
                    //Check if time falls between opening and closing
                    for (Schedule *schedule in deal.schedule) {
                        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[deal.finalWeekSchedule length]];
                        int weekday = [self currentWeekday];
                        for (int i=0; i < [schedule.weekSchedule length]; i++) {
                            NSString *ichar  = [NSString stringWithFormat:@"%c", [schedule.weekSchedule characterAtIndex:i]];
                            if ([ichar isEqualToString:@"1"] && i == weekday) {
                                if (![self isMerchantOpen:schedule]) {
                                    return NO;
                                    
                                }
                            }
                        }
                        
                        
                    }
                }
                else{
                    return NO;
                }
            }
            else{
//                if (![deal.weekdaysArray containsObject:[NSString stringWithFormat:@"%d",[self currentWeekday]]]) {
//                    int weekday = [self currentWeekday];
//
//                    //Check if time falls between opening and closing
//                    for (Schedule *schedule in deal.schedule) {
//                        for (int i=0; i < [schedule.weekSchedule length]; i++) {
//                            NSString *ichar  = [NSString stringWithFormat:@"%c", [schedule.weekSchedule characterAtIndex:i]];
//                            if ([ichar isEqualToString:@"1"] && i == weekday) {
//                                if ([self isMerchantOpen:schedule]) {
//                                    return NO;
//                                }
//                            }
//                        }
//                        
//                        
//                    }
//                }
//                else{
//                    return NO;
//                }
                
            }

        }
        if([key isEqualToString:@"3.5+"]){
            
            DLog(@"deal rating %f",deal.rating.floatValue);
            
            if ([localFilterDict[key] isEqual:@(1)]) {
                //
                if (deal.rating.floatValue<3.5) {
                    return NO;
                }
            }
            
        }
        if([key isEqualToString:@"gender"]){
            if ([localFilterDict[key] isEqualToString:@"male"]) {
                if (![deal.genderSupport isEqualToString:@"1"]) {
                    return NO;
                }
            }
            else if ([localFilterDict[key] isEqualToString:@"female"]) {
                if (![deal.genderSupport isEqualToString:@"0"]) {
                    return NO;
                }
            }
            else{
                if (![deal.genderSupport isEqualToString:@"2"]) {
                    return NO;
                }
            }
        }
        if ([key isEqualToString:@"athome"]) {
            if ([localFilterDict[key] isEqual:@(1)]) {
                if ([deal.homeService isEqualToString:@"0"]) {
                    return NO;
                }
            }
            if ([localFilterDict[key] isEqual:@(0)]) {
                if ([deal.homeService isEqualToString:@"1"]) {
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }
    else{
        NSString *identifier =  @"DealCellIdentifier";
        Deal *deal = arrayOfDeals[indexPath.row];
        DealListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
        
        NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:deal];

        cell.favoriteButton.selected = ([myDealsArray containsObject:dealData])?YES:NO;
        cell.nameLabel.text = [deal.name uppercaseString];
        cell.addressLabel.text = [deal.address uppercaseString];
       
        if(deal.distanceFromCurrentLocation.floatValue == 0.0){
            cell.distanceLabel.hidden = YES;
            cell.distanceBackgroundImageView.hidden = YES;
            
        }
        else{
            NSString *distanceString = [NSString stringWithFormat:@"%.1f m",deal.distanceFromCurrentLocation.doubleValue];
            if(deal.distanceFromCurrentLocation.doubleValue > 1000){
                distanceString = [NSString stringWithFormat:@"%.1f km",deal.distanceFromCurrentLocation.doubleValue/1000];
            }
            cell.distanceLabel.text = distanceString;

            cell.distanceBackgroundImageView.hidden = NO;
        }
        [cell setServiceCategoryImagesWithDeal:deal];
        cell.favoriteButton.tag = indexPath.row;
        cell.averageRating.text = deal.rating;
        cell.amountOffLabel.text = (deal.percentOff)?[NSString stringWithFormat:@"%@%% off",deal.percentOff]:[NSString stringWithFormat:@"%@Rs off",deal.flatOff];
        
        double unixTimeStamp = [deal.validTill doubleValue];
        DLog(@"unix time stamp %@ %f",deal.validTill,unixTimeStamp);
        
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setLocale:[NSLocale currentLocale]];
        [_formatter setDateFormat:@"dd.MM.yyyy"];
        NSString *validTilldate=[_formatter stringFromDate:date];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.validTillLabel.text = [NSString stringWithFormat:@"Valid till %@",validTilldate];
        return cell;
    }
    
    return nil;
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searching) {
        SuggestedTableViewCell *cell = (SuggestedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        searchText = [cell.searchLabel.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        [self loadNewDealsWithSpinner];
    }
    else{
        selectedDeal = arrayOfDeals[indexPath.row];
        [self performSegueWithIdentifier:@"showDealDetails" sender:self];
    }
    
}

#pragma mark - User Actions

-(IBAction)favouriteDeal:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    int index = senderButton.tag;
    Deal *deal = arrayOfDeals[index];
    NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:deal];

    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:MYUSERSTORE];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];

    if (senderButton.selected) {
        [myDealsArray removeObject:dealData];
      }
    else{
        [myDealsArray addObject:dealData];

    }
    
    user.deals = [NSString stringWithFormat:@"%lu",(unsigned long)myDealsArray.count];
    NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [user saveArchivedUserData:archivedUser];
    
    [[NSUserDefaults standardUserDefaults] setObject:myDealsArray forKey:MYDEALSSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableview reloadData];
}

-(IBAction)showFilterScreen:(id)sender{
    [self performSegueWithIdentifier:@"showFilter" sender:self];

}

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

    [self pickUpLocallyStoredMerchantResponse];
    
   
    
    
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
                
                DLog(@"response string %@",responseDict);
                
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
