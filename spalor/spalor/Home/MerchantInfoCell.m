//
//  MerchantInfoCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantInfoCell.h"
#import "LocationHelper.h"
#import <CoreLocation/CoreLocation.h>

@implementation MerchantInfoCell

-(MerchantInfoCell *)setupWithMerchant:(Merchant *)merchant{
    self.nameLabel.text = merchant.name;
    self.addressLabel.text = merchant.address;
    self.averageRatingLabel.text = merchant.rating;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:merchant.geo.lat.floatValue longitude:merchant.geo.lon.floatValue];
    CGFloat distance = [[LocationHelper sharedInstance] distanceInmeteresFrom:location];
    if(distance == -1.0){
        self.distanceLabel.hidden = YES;

    }
    else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%f",distance];

    }
    self.profileImageView.image = [UIImage imageNamed:@""];
    return self;
}
@end
