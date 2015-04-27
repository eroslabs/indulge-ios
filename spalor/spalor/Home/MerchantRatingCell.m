//
//  MerchantRatingCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantRatingCell.h"

@implementation MerchantRatingCell
-(MerchantRatingCell *)setupWithMerchant:(Merchant *)merchant{
    self.rateView.notSelectedImage = [UIImage imageNamed:@"kermit_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"kermit_full.png"];
    self.rateView.rating = merchant.rating.floatValue;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;
    self.userName.text = @"";
    self.userImageView.image = [UIImage imageNamed:@""];
    return self;
}
@end
