//
//  DealDetailsViewController.m
//  spalor
//
//  Created by Manish on 24/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealDetailsViewController.h"

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
        case 0:
            identifier = @"dealCellIdentifier";
            break;
        case 1:
            identifier = @"socialCellIdentifier";
            break;
        case 2:
            identifier = @"redeemCellIdentifier";
            break;
        case 3:
            identifier = @"timingCellIdentifier";
            break;
        case 4:
            identifier = @"priceRangeCell";
            break;
        case 5:
            identifier = @"recomendedCellIdentifier";
            break;
        case 6:
            identifier = @"extraServicesCellIdentifier";
            break;
        default:
            break;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}


#pragma mark - User Actions

-(IBAction)goBackToSearch:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)redeemDeal:(id)sender{
    
}



@end
