//
//  DealDetailsViewController.m
//  spalor
//
//  Created by Manish on 24/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealDetailsViewController.h"
#import "DealListCell.h"
#import "DealSocialCell.h"
#import "DealRedeemCell.h"
#import "DealTimingCell.h"
#import "DealPriceCell.h"
#import "DealRecommendedCell.h"
#import "DealExtraServicesCell.h"
#import "NetworkHelper.h"
#import "FeSpinnerTenDot.h"
#import "RedeemDealViewController.h"
#import "User.h"

@interface DealDetailsViewController (){
    FeSpinnerTenDot *spinner;
    NSString *couponCode;
    UIImage *snapShotOfCell;
    NSMutableArray *myDealsArray;

}

@end

@implementation DealDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Selected Deal %@",self.deal.name);
    myDealsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:MYDEALSSTORE]];

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
            return 90;
            break;
        case 2:
            return 63;
            break;
        case 3:
            return 100;
            break;
        case 4:
            return 80;
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

-(UIImage *)snapShotOfView:(UIView *)viewToRender{
    UIGraphicsBeginImageContextWithOptions(viewToRender.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [viewToRender drawViewHierarchyInRect:viewToRender.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:{
            identifier = @"DealCellIdentifier";
            DealListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            return cell;
            break;
        }
        case 1:{
            identifier = @"socialCellIdentifier";
            DealSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupCellWithDeal:self.deal];
            NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:self.deal];
            
            cell.favoriteButton.selected = ([myDealsArray containsObject:dealData])?YES:NO;

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

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
//    if (snapShotOfCell == nil && indexPath.row == 0) {
//        snapShotOfCell = [self snapShotOfView:cell.contentView];
//    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (snapShotOfCell == nil && indexPath.row == 0) {
//        snapShotOfCell = [self snapShotOfView:cell.vi];
//    }
}

#pragma mark - User Actions

-(IBAction)goBackToSearch:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)favouriteDeal:(id)sender{
    
    UIButton *senderButton = (UIButton *)sender;
    NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:self.deal];
    
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


-(IBAction)call:(id)sender{
    NSString *cleanedString = [[self.deal.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];
}

-(IBAction)redeemDeal:(id)sender{
    [self hideRedeemConfirmation:NO];
}

-(IBAction)acceptRedeem:(id)sender{
    // Send Redeem Request
    // then
    // Push Segue
    spinner = [[FeSpinnerTenDot alloc] initWithView:self.overlayView withBlur:NO];
    [self.overlayView addSubview:spinner];
    [spinner showWhileExecutingSelector:@selector(confirmDealRequest) onTarget:self withObject:nil];
}

-(void)confirmDealRequest{
    
    if (!self.deal.dealId) {
        [spinner dismiss];
        [spinner removeFromSuperview];
        //Show Error Alert
        UIAlertView *redeemError = [[UIAlertView alloc] initWithTitle:@"Redeem Error" message:@"Unable to redeem right now please come back later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [redeemError show];
        
        //Temporary Push Segue
        couponCode = @"A123456789";
        NSMutableArray *myDealsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:MYDEALSSTORE]];
        self.deal.couponCode = couponCode;
        NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:self.deal];
        [myDealsArray addObject:dealData];
        
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:MYUSERSTORE];
        User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        user.deals = [NSString stringWithFormat:@"%lu",(unsigned long)myDealsArray.count];
        NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
        [user saveArchivedUserData:archivedUser];
        
        [[NSUserDefaults standardUserDefaults] setObject:myDealsArray forKey:MYDEALSSTORE];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self performSegueWithIdentifier:@"RedeemDeal" sender:nil];
        return;
    }
    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:[NSString stringWithFormat:@"user/redeem/%@",self.deal.dealId] withParameters:@{@"userEmail":@"manish@eroslabs.co"} completionHandler:^(id response, NSString *url, NSError *error){
        if (error == nil && response!=nil) {
            dispatch_async (dispatch_get_main_queue(), ^{
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"response Dict %@",responseDict);
                [spinner dismiss];
                [spinner removeFromSuperview];
                //Push Segue
                couponCode = responseDict[@"coupon"];
                NSMutableArray *myDealsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:MYDEALSSTORE]];
                self.deal.couponCode = couponCode;

                NSData *dealData = [NSKeyedArchiver archivedDataWithRootObject:self.deal];
                [myDealsArray addObject:dealData];
                NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:MYUSERSTORE];
                User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
                user.deals = [NSString stringWithFormat:@"%lu",(unsigned long)myDealsArray.count];
                NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
                [user saveArchivedUserData:archivedUser];
                
                [[NSUserDefaults standardUserDefaults] setObject:myDealsArray forKey:MYDEALSSTORE];
                NSLog(@"saving deal %@ %@",self.deal.name,self.deal.couponCode);
                [[NSUserDefaults standardUserDefaults] setObject:myDealsArray forKey:MYDEALSSTORE];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self hideRedeemConfirmation:YES];

                [self performSegueWithIdentifier:@"RedeemDeal" sender:nil];
            });
        }
        else{
            dispatch_async (dispatch_get_main_queue(), ^{
                [spinner dismiss];
                [spinner removeFromSuperview];
                //Show Error Alert
                UIAlertView *redeemError = [[UIAlertView alloc] initWithTitle:@"Redeem Error" message:@"Unable to redeem right now please come back later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [redeemError show];
                [self hideRedeemConfirmation:YES];

//                //Temporary Push Segue
//                couponCode = @"A123456789";
//                [self performSegueWithIdentifier:@"RedeemDeal" sender:nil];
            });
            
        }
    }];
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

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"RedeemDeal"]) {
        RedeemDealViewController *controller = (RedeemDealViewController *)[segue destinationViewController];
        controller.deal = self.deal;
        controller.couponCode = couponCode;
    }
}


@end
