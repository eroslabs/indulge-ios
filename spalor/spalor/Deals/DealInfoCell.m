//
//  DealInfoCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealInfoCell.h"

@implementation DealInfoCell

-(DealInfoCell *)setupCellWithDeal:(Deal *)deal{
    self.nameLabel.text = deal.name;
    self.addressLabel.text = deal.address;
    self.averageRating.text = deal.rating;
    if(deal.distanceFromCurrentLocation.floatValue == 0.0){
        self.distanceLabel.hidden = YES;
        
    }
    else{
        self.distanceLabel.text = deal.distanceFromCurrentLocation;
        
    }
    self.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
    self.amountOffLabel.text = (deal.percentOff)?[NSString stringWithFormat:@"%@%% off",deal.percentOff]:[NSString stringWithFormat:@"%@Rs off",deal.flatOff];
    
    return self;
}

@end
