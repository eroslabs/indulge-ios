//
//  MerchantInfoCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageEffects.h"

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
    
    
    NSString *urlString = (merchant.image.length)?[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,merchant.image]:[NSString stringWithFormat:STATIC_IMAGE_SOURCE];

    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.profileImageView setImageWithURL:url
                          placeholderImage:[UIImage imageNamed:@"placeholder1.png"] options:SDWebImageProgressiveDownload ];
    

    return self;
}
@end
