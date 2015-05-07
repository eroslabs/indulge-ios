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
    
    if(merchant.distanceFromCurrentLocation.floatValue == 0.0){
        self.distanceLabel.hidden = YES;

    }
    else{
        self.distanceLabel.text = merchant.distanceFromCurrentLocation;

    }
    self.profileImageView.image = [UIImage imageNamed:@"12.png"];
    return self;
}
@end
