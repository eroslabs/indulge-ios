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
    NSLog(@"Selected Deal %@",self.deal.name);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Datasource and Delegate
- (NSInteger)numberOfSections{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 7;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
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


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
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
    [self hideRedeemConfirmation:NO];
}

-(IBAction)acceptRedeem:(id)sender{
    //Push Segue
}

-(IBAction)rejectRedeem:(id)sender{
    [self hideRedeemConfirmation:YES];

}

-(void)hideRedeemConfirmation:(BOOL)hidden{

    [UIView animateWithDuration:0.3 animations:^{
        if (!hidden) {
            self.overlayView.alpha = 0.8;
            self.acceptRejectView.alpha = 1;
            self.redeemTextView.alpha = 1;
        }
        else{
            self.overlayView.alpha = 0;
            self.acceptRejectView.alpha = 0;
            self.redeemTextView.alpha = 0;
            
        }
    }];
}


@end
