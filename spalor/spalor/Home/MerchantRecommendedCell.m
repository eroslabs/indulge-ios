//
//  MerchantRecommendedCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantRecommendedCell.h"

@implementation MerchantRecommendedCell
-(MerchantRecommendedCell *)setupWithMerchant:(Merchant *)merchant{
    self.recommendedLabel.text = [NSString stringWithFormat:@"Recommended : %@",merchant.recommendedService];
    return self;
}
@end
