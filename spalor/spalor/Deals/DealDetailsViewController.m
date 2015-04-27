//
//  DealDetailsViewController.m
//  spalor
//
//  Created by Manish on 24/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealDetailsViewController.h"
#import "DealInfoCell.h"
#import "DealSocialCell.h"
#import "DealRedeemCell.h"
#import "DealTimingCell.h"
#import "DealPriceCell.h"
#import "DealRecommendedCell.h"
#import "DealExtraServicesCell.h"

@interface DealDetailsViewController ()

@end

@implementation DealDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Datasource and Delegate
- (NSInteger)numberOfSections{
    return 7;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 1;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 160;
            break;
        case 1:
            return 63;
            break;
        case 2:
            return 63;
            break;
        case 3:
            return 160;
            break;
        case 4:
            return 160;
            break;
        case 5:
            return 63;
            break;
        case 6:
            return 63;
            break;
        default:
            break;
    }
    
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (indexPath.section) {
            case
    }
    return @"";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.section) {
        case 0:{
            identifier = @"dealCellIdentifier";
            DealInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        case 1:{
            identifier = @"socialCellIdentifier";
            DealSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        case 2:{
            identifier = @"redeemCellIdentifier";
            DealRedeemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        case 3:{
            identifier = @"timingCellIdentifier";
            DealTimingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        case 4:{
            identifier = @"priceRangeCell";
            DealPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        case 5:{
            identifier = @"recomendedCellIdentifier";
            DealRecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        case 6:{
            identifier = @"extraServicesCellIdentifier";
            DealExtraServicesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        default:
            break;
    }
    
    return nil;
}


#pragma mark - User Actions

-(IBAction)goBackToSearch:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)redeemDeal:(id)sender{
    
}



@end
