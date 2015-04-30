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
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (arrayOfDeals.count == 0) {
        spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
        [self.loaderContainerView addSubview:spinner];
        self.loaderContainerView.hidden = NO;
        [spinner showWhileExecutingSelector:@selector(searchForNewDeals) onTarget:self withObject:nil];
    }
    
}

-(void)searchForNewDeals{
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/searchDeals" withParameters:@{@"s":@"venus"} completionHandler:^(id response, NSString *url, NSError *error){
        
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"DealResponse"];
            
            
            if (responseDict) {
                arrayOfDeals = [self captureAllMerchantsFromResponseDict:responseDict];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner dismiss];
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
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.textLabel.text = data[indexPath.row];
        return cell;

    }
    else{
        NSString *identifier =  @"DealCellIdentifier";
        Deal *deal = arrayOfDeals[indexPath.row];
        DealListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
        
        cell.nameLabel.text = deal.name;
        cell.addressLabel.text = deal.address;
        cell.distanceLabel.text = @"500 m";
        cell.averageRating.text = deal.rating;
        cell.amountOffLabel.text = (deal.percentOff)?deal.percentOff:deal.amountOff;
        return cell;
    }
    
    return nil;
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedDeal = arrayOfDeals[indexPath.row];
    [self performSegueWithIdentifier:@"showDealDetails" sender:self];
    
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
        searchText = textField.text;
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
