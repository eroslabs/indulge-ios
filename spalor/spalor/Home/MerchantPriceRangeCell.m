//
//  MerchantPriceRangeCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantPriceRangeCell.h"

@implementation MerchantPriceRangeCell
-(MerchantPriceRangeCell *)setupWithMerchant:(Merchant *)merchant{
    self.priceRangeImageView.image = [UIImage imageNamed:@"merchant-rupee4.png"];
    return self;
}
@end
