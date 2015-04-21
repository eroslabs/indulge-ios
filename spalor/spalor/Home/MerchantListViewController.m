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

@interface MerchantListViewController (){
    NSArray *arrayOfMerchants;
    FeSpinnerTenDot *spinner;
}

@end

@implementation MerchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    spinner = [[FeSpinnerTenDot alloc] initWithView:self.loaderContainerView withBlur:NO];
    [self.loaderContainerView addSubview:spinner];
    self.loaderContainerView.hidden = NO;
    //self.view.backgroundColor = [UIColor colorWithHexCode:@"#019875"];
    [spinner showWhileExecutingSelector:@selector(searchForNewMerchants) onTarget:self withObject:nil];
   //    [self pickUpLocallyStoredMerchantResponse];

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
    
    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/searchMerchant" withParameters:@{@"s":@"abc",@"hs":@"1",@"services":@"1,2,3,4,5",@"lat":@"28.9",@"lon":@"23.4",@"page":@"0",@"limit":@"20",@"sort":@"distance",@"dir":@"asc",@"pt":@"500"}  completionHandler:^(id response, NSString *url, NSError *error){
        
            if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
                
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"MerchantResponse"];
            
                
            NSLog(@"response Data %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"MerchantResponse"]);

            if (responseDict) {
                arrayOfMerchants = [self captureAllMerchantsFromResponseDict:responseDict];
            }
            
            NSLog(@"array of merchants %@",arrayOfMerchants);
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner dismiss];
                    self.totalCountLabel.text = [NSString stringWithFormat:@"%d Items",arrayOfMerchants.count];
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
    
    
    
    //          NSLog(@"response Dict %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"MerchantResponse"]
    
    
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
        
        //Double up merchants for now
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
    cell.averageRating.text = merchant.rating;;
    cell.distanceLabel.text = @"500 m";// Need to calculate this at runtime
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
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}


#pragma mark - User Actions

-(IBAction)goBackToSearch:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
