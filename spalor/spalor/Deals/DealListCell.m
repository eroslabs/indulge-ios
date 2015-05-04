//
//  DealListCell.m
//  spalor
//
//  Created by Manish on 20/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealListCell.h"
#import "Deal.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationHelper.h"

@implementation DealListCell
-(DealListCell *)setupCellWithDeal:(Deal *)deal{
    self.nameLabel.text = deal.name;
    self.addressLabel.text = deal.address;
    self.averageRating.text = deal.rating;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:deal.geo.lat.floatValue longitude:deal.geo.lon.floatValue];
    
    CGFloat distance = [[LocationHelper sharedInstance] distanceInmeteresFrom:location];
    if(distance == -1.0){
        self.distanceLabel.hidden = YES;
        
    }
    else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%f",distance];
        
    }
    self.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
    self.amountOffLabel.text = (deal.percentOff)?deal.percentOff:deal.amountOff;
    
    return self;
}
@end
