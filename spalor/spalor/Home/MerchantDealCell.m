//
//  MerchantDealCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantDealCell.h"

@implementation MerchantDealCell
-(MerchantDealCell *)setupWithMerchant:(Merchant *)merchant{
    self.amountOffLabel.text = @"500 Rs Off";
    self.servicesLabel.text = @"X Y Z";
    self.validTillLabel.text = @"Valid Till X Y Z";
    return self;
}
@end
