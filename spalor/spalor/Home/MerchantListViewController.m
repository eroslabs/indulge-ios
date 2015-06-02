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
#import <SDWebImage/UIImageView+WebCache.h>
#import "MerchantCategoriesDealPopupCell.h"
#import "DealDetailsViewController.h"
#import "MerchantServicesDealPopupCell.h"

@interface MerchantListViewController (){
    NSArray *arrayOfMerchants;
    FeSpinnerTenDot *spinner;
    Merchant *selectedMerchant;
    Deal *selecteddeal;
    NSMutableDictionary *localFilterDict;
    NSMutableArray *myMerchantsArray;
}

@end

@implementation MerchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
    [self.loaderContainerView addSubview:spinner];
    self.loaderContainerView.hidden = NO;
    [self.view bringSubviewToFront:self.dealOverlayView];
    [spinner showWhileExecutingSelector:@selector(searchForNewMerchants) onTarget:self withObject:nil];
    myMerchantsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:MYMERCHANTSSTORE]];
    localFilterDict = [[NSUserDefaults standardUserDefaults] objectForKey:MYLOCALFILTERSTORE];
    [self setButtonsFromLocalFilters];
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
                
            if (responseDict[@"error"]) {
                dispatch_async (dispatch_get_main_queue(), ^{
                    [spinner dismiss];
                    [spinner removeFromSuperview];
                    //Show Error Alert
                    UIAlertView *redeemError = [[UIAlertView alloc] initWithTitle:@"Redeem Error" message:responseDict[@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [redeemError show];
                    self.loaderContainerView.hidden = YES;
                    
                });
            }
            else{
                if (responseDict) {
                    arrayOfMerchants = [self captureAllMerchantsFromResponseDict:responseDict];
                    if (arrayOfMerchants.count>0) {
                        
                        //Only put if there was no error
                        [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"MerchantResponse"];
                        
                        arrayOfMerchants = [self sortedMerchantArray:arrayOfMerchants];
                        
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

                
            
        }
        else{
            NSLog(@"error %@",[error localizedDescription]);
        }
    }];
     
    

}

-(void)pickUpLocallyStoredMerchantResponse{
    NSData *response = [[NSUserDefaults standardUserDefaults] objectForKey:@"MerchantResponse"];
    
    NSError *error = nil;
    if (response == nil) {
        return;
    }
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"response string %@",responseDict);
    
    if(error) {  //Handle error
        NSLog(@"error %@",[error localizedDescription]);
        
    }
    else{
        NSLog(@"response string %@",responseDict);
        
        if (responseDict) {
            arrayOfMerchants = [self captureAllMerchantsFromResponseDict:responseDict];
            if (arrayOfMerchants.count>0) {
                // Now Apply sorting
                
                arrayOfMerchants = [self sortedMerchantArray:arrayOfMerchants];
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
        
        merchantArray = [self sortedMerchantArray:merchantArray];
    }
    return merchantArray;
}

-(NSMutableArray *)sortedMerchantArray:(NSMutableArray *)merchantArray{
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
    NSString *closingHr = closingArray[0];
    NSString *closingMin = closingArray[1];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDateComponents *dateComps = [gregorianCal components: (NSCalendarUnitHour | NSCalendarUnitMinute)
                                                  fromDate: [NSDate date]];
    // Then use it
    NSInteger currentMin = [dateComps minute];
    NSInteger currentHr = [dateComps hour];
    
    NSInteger currentHrForClosingCheck = (currentHr>12)?(currentHr-12):currentHr;
    
    NSLog(@"current hr %d current min %d closinghr %d closing min %d openinghr %d openingmin %d",currentHr,currentMin,closingHr.integerValue,closingMin.integerValue,openingHr.integerValue,openingMin.integerValue);
    
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

-(BOOL)isMerchantPassedFromLocalFilter:(Merchant *)merchant{
    
    NSLog(@"keys %@",[localFilterDict allKeys]);
    
    for (NSString *key in [localFilterDict allKeys]) {
        
        
        
        NSLog(@"key %@",key);
        
        
        
        if([key isEqualToString:@"opennow"]){
            if ([localFilterDict[key] isEqual:@(1)]) {
                if ([merchant.weekdaysArray containsObject:[NSString stringWithFormat:@"%d",[self currentWeekday]]]) {
                    //Check if time falls between opening and closing
                    for (Schedule *schedule in merchant.schedule) {
                        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[merchant.finalWeekSchedule length]];
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
                if (![merchant.weekdaysArray containsObject:[NSString stringWithFormat:@"%d",[self currentWeekday]]]) {
                    //Check if time falls between opening and closing
                    for (Schedule *schedule in merchant.schedule) {
                        NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[merchant.finalWeekSchedule length]];
                        int weekday = [self currentWeekday];
                        for (int i=0; i < [schedule.weekSchedule length]; i++) {
                            NSString *ichar  = [NSString stringWithFormat:@"%c", [schedule.weekSchedule characterAtIndex:i]];
                            if ([ichar isEqualToString:@"1"] && i == weekday) {
                                if ([self isMerchantOpen:schedule]) {
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
            
        }
        if([key isEqualToString:@"3.5+"]){
            if ([localFilterDict[key] isEqual:@(1)] && merchant.rating.floatValue<3.5) {
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
    if([tableView isEqual:self.dealTableView]){
        return selectedMerchant.deals.count;
    }
    
    NSInteger numOfRows = arrayOfMerchants.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.dealTableView]){
        return 56;
    }
    return 174;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:self.dealTableView]){
       //Two cells Services and Categories
        Deal *deal = selectedMerchant.deals[indexPath.row];
        NSString *identifier =  (deal.serviceNames.count>0)?@"ServicesIdentifier":@"CategoriesIdentifier";
        if([identifier isEqualToString:@"ServicesIdentifier"]){
            MerchantServicesDealPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            NSMutableString *serviceNameString = [NSMutableString new];
            cell.servicesLabel.text = [deal.serviceNames componentsJoinedByString:@","];
            cell.serviceDetailsLabel.text = (deal.percentOff)?[NSString stringWithFormat:@"%@%% Off",deal.percentOff]:[NSString stringWithFormat:@"%@ Rs Off",deal.flatOff];
            return cell;
        }
        else{
            MerchantCategoriesDealPopupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            //Set category Image Views here
            cell.serviceDetailsLabel.text = (deal.percentOff)?[NSString stringWithFormat:@"%@%% Off",deal.percentOff]:[NSString stringWithFormat:@"%@ Rs Off",deal.flatOff];
            return cell;
        }
    }
    
    
    NSString *identifier =  @"MerchantIdentifier";
    Merchant *merchant = arrayOfMerchants[indexPath.row];
    MerchantListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.nameLabel.text = [merchant.name capitalizedString];
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
    
    
    NSString *urlString = (merchant.image.length)?[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,merchant.image]:[NSString stringWithFormat:STATIC_IMAGE_SOURCE];
    
    NSURL *url = [NSURL URLWithString:urlString];

    NSLog(@"url %@",urlString);
    
    [cell.backgroundImageView setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"placeholder1.png"] options:SDWebImageProgressiveDownload];

    cell.dealsButton.selected = (merchant.deals.count)?YES:NO;
    cell.dealsButton.tag = indexPath.row;
    cell.distancebackgroundImageView.image = [UIImage imageNamed:@"merchant-location.png"];
    [cell.callButton setImage:[UIImage imageNamed:@"merchant-listing-call.png"] forState:UIControlStateNormal];
    [cell.shareButton setImage:[UIImage imageNamed:@"merchant-share.png"] forState:UIControlStateNormal];
    
    NSData *encodedMerchant = [NSKeyedArchiver archivedDataWithRootObject:merchant];
    cell.favoriteButton.selected = ([myMerchantsArray containsObject:encodedMerchant])?YES:NO;
    [cell.favoriteButton addTarget:self action:@selector(favourite:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dealsButton setImage:[UIImage imageNamed:@"merchant-listing-deal.png"] forState:UIControlStateNormal];
    [cell.dealsButton addTarget:self action:@selector(favourite:) forControlEvents:UIControlEventTouchUpInside];
    cell.serviceCategorybackgroundImageView.image = [UIImage imageNamed:@"merchant-categories-bar.png"];
    
    [cell setServiceCategoryImagesWithMerchant:merchant];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:self.dealTableView]){
        //Show Deal Segue
        selecteddeal = selectedMerchant.deals[indexPath.row];
        [self performSegueWithIdentifier:@"ShowDealDetail" sender:nil];
    }
    else{
        selectedMerchant = arrayOfMerchants[indexPath.row];
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

#pragma mark - User Actions

-(IBAction)showDealPopup:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    selectedMerchant = arrayOfMerchants[senderButton.tag];
    if(selectedMerchant.deals.count>0){
        self.selectedMerchantName.text = [selectedMerchant.name capitalizedString];
        self.selectedMerchantAddress.text = [selectedMerchant.address capitalizedString];
        [UIView animateWithDuration:0.3f animations:^{
            self.dealOverlayView.alpha = 1;
            [self.dealTableView reloadData];
            
        }];

    }
}

-(IBAction)hideDealPopup:(id)sender{
    [UIView animateWithDuration:0.3f animations:^{
        self.dealOverlayView.alpha = 0;
        
    }];
}

-(IBAction)share:(id)sender{
    NSString *texttoshare = @"MY TEXT"; //this is your text string to share
    UIImage *imagetoshare = [UIImage imageNamed:@"merchant-massage.png"]; //this is your image to share
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}


-(void)favourite:(UIButton *)senderButton{
    Merchant *merchant = arrayOfMerchants[senderButton.tag];
    NSData *myEncodedMerchant = [NSKeyedArchiver archivedDataWithRootObject:merchant];
    
    if (senderButton.selected) {
        [myMerchantsArray removeObject:myEncodedMerchant];
    }
    else {
        [myMerchantsArray addObject:myEncodedMerchant];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:myMerchantsArray forKey:MYMERCHANTSSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableview reloadData];
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
    
    NSMutableArray *newMerchantArray = [NSMutableArray new];
    [self pickUpLocallyStoredMerchantResponse];
    
   
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
    else if([segue.identifier isEqualToString:@"ShowDealDetail"]){
        DealDetailsViewController *controller = (DealDetailsViewController *)segue.destinationViewController;
        controller.deal = selecteddeal;
    }
}

@end
