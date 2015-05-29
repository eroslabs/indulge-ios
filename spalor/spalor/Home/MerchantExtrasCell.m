//
//  MerchantExtrasCell.m
//  spalor
//
//  Created by Manish on 27/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantExtrasCell.h"

@implementation MerchantExtrasCell
-(MerchantExtrasCell *)setupWithMerchant:(Merchant *)merchant{
    self.extrasLabel.text = (merchant.ccAccepted)?@"Credit Cards accepted!":@"Credit Cards NOT accepted";
    return self;
}
@end
