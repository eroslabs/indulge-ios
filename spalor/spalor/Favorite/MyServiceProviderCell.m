//
//  MyServiceProviderCell.m
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MyServiceProviderCell.h"

@implementation MyServiceProviderCell
-(void)setupCellWithMerchant:(Merchant *)merchant{
    self.nameLabel.text = merchant.name;
    self.addressLabel.text = merchant.address;
    self.ratingLabel.text = merchant.rating;
    self.locationLabel.text = @"500 m";
}
@end
