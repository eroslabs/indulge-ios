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
#import "Deal.h"

@interface DealsViewController (){
    NSArray *arrayOfDeals;
}
@end

@implementation DealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self searchForNewDeals];
}

-(void)searchForNewDeals{
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/searchDeals" withParameters:@{@"s":@"abc"} completionHandler:^(id response, NSString *url, NSError *error){
        
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"DealResponse"];
            
            
            if (responseDict) {
                arrayOfDeals = [self captureAllMerchantsFromResponseDict:responseDict];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
            });
            
        }
        else{
            NSLog(@"error %@",[error localizedDescription]);
        }
    }];

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
    NSInteger numOfRows = arrayOfDeals.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =  @"DealCellIdentifier";
    Deal *deal = arrayOfDeals[indexPath.row];
    DealListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
    //Left cap is the space you dont wanna stretch on the left side and right side of the image
    int leftCap = 30;
    //Left cap is the space you dont wanna stretch on the top side and bottom side of the image
    int topCap = 20;
    //this will only stretch the inner side of the image
    cell.backgroundImageView.image = [cell.backgroundImageView.image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];

    cell.nameLabel.text = deal.name;
    cell.addressLabel.text = deal.address;
    cell.distanceLabel.text = @"500 m";
    cell.averageRating.text = deal.rating;
    cell.amountOffLabel.text = (deal.percentOff)?deal.percentOff:deal.amountOff;
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDealDetails" sender:self];
    
}

#pragma mark - User Actions
-(IBAction)showFilterScreen:(id)sender{
    [self performSegueWithIdentifier:@"showFilter" sender:self];

}



@end
