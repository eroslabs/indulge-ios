//
//  AllMerchantsViewController.m
//  spalor
//
//  Created by Manish on 14/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "AllMerchantsViewController.h"
#import "MyServiceProviderCell.h"

@interface AllMerchantsViewController ()

@end

@implementation AllMerchantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Datasource and Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = self.dataArray.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = @"MyServiceProviderCell";//This is your favorite Merchants
    MyServiceProviderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    Merchant *myMerchant = [NSKeyedUnarchiver unarchiveObjectWithData:self.dataArray[indexPath.row]];
    DLog(@"myMerchant %@",myMerchant.name);
    [cell setupCellWithMerchant:myMerchant];
    return cell;
}





#pragma mark - User Actions

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
