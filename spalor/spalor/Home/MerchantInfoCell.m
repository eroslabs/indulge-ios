//
//  MerchantInfoCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantInfoCell.h"

@implementation MerchantInfoCell

-(MerchantInfoCell *)setupWithMerchant:(Merchant *)merchant{
    self.nameLabel.text = merchant.name;
    self.addressLabel.text = merchant.address;
    self.averageRatingLabel.text = merchant.rating;
    self.distanceLabel.text = @"500 m";
    self.profileImageView.image = [UIImage imageNamed:@""];
    return self;
}
@end
