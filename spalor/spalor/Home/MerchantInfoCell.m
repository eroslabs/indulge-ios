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
        
        NSString *distanceString = [NSString stringWithFormat:@"%.1f m",merchant.distanceFromCurrentLocation.doubleValue];
        if(merchant.distanceFromCurrentLocation.doubleValue > 1000){
            distanceString = [NSString stringWithFormat:@"%.1f km",merchant.distanceFromCurrentLocation.doubleValue/1000];
        }
        self.distanceLabel.text = distanceString;
        

    }
    
    self.rateView.hidden = NO;
    self.rateView.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"star.png"];
    self.rateView.rating = merchant.rating.floatValue;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;

    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
    
    NSString *urlString = (merchant.image.length)?[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,merchant.image]:[NSString stringWithFormat:STATIC_IMAGE_SOURCE];

    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.profileImageView setImageWithURL:url
                          placeholderImage:[UIImage imageNamed:@"placeholder1.png"] options:SDWebImageProgressiveDownload ];
    

    return self;
}
@end
