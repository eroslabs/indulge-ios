//
//  MerchantPriceRangeCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface MerchantPriceRangeCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *priceRangeImageView;
@property (nonatomic,weak) IBOutlet UILabel *deal1;
@property (nonatomic,weak) IBOutlet UILabel *deal2;
@property (nonatomic,weak) IBOutlet UILabel *deal3;

-(MerchantPriceRangeCell *)setupWithMerchant:(Merchant *)merchant;
@end
