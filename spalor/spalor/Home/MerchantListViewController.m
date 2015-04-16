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

@interface MerchantListViewController (){
    NSArray *arrayOfMerchants;
}

@end

@implementation MerchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"user/getMerchant" withParameters:@{@"s":@"abc",@"hs":@"1",@"services":@"1,2,3,4,5",@"point":@"34.5,34.5",@"page":@"0,distance,asc"} completionHandler:^(id response, NSString *url, NSError *error){
//        if (!error) {
//            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
//            
//            NSLog(@"response string %@",responseDict);
//        
//            arrayOfMerchants = [self captureAllMerchantsFromResponseDict:responseDict];
//            
//            NSLog(@"array of merchants %@",arrayOfMerchants);
//
//        }
//        else{
//            NSLog(@"error %@",[error localizedDescription]);
//        }
//    }];

}

-(NSArray *)captureAllMerchantsFromResponseDict:(NSDictionary *)dictionary{
   
    NSArray *resultArray = dictionary[@"result"];
    NSMutableArray *merchantArray = [NSMutableArray new];
    
    for (NSDictionary *merchantDict in resultArray) {
        
        Merchant *merchant = [[Merchant alloc] init];
        [merchant readFromDictionary:merchantDict];
        
        NSLog(@"merchant %@",merchant);
        
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
    NSInteger numOfRows = 10;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =  @"MerchantIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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
