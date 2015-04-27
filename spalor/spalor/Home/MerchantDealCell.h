//
//  MerchantDealCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface MerchantDealCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *amountOffLabel;
@property (nonatomic, weak) IBOutlet UILabel *servicesLabel;
@property (nonatomic, weak) IBOutlet UILabel *validTillLabel;
@property (nonatomic, weak) IBOutlet UIButton *redeemButton;
-(MerchantDealCell *)setupWithMerchant:(Merchant *)merchant;

@end
