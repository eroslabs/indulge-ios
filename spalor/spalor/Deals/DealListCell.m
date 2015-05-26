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
    if(deal.distanceFromCurrentLocation.floatValue == 0.0){
        self.distanceLabel.hidden = YES;
        
    }
    else{
        self.distanceLabel.text = deal.distanceFromCurrentLocation;
        
    }
    self.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
    self.amountOffLabel.text = (deal.percentOff)?[NSString stringWithFormat:@"%@%% off",deal.percentOff]:[NSString stringWithFormat:@"%@Rs off",deal.flatOff];
    
    double unixTimeStamp = [deal.validTill doubleValue];
    NSLog(@"unix time stamp %@ %f",deal.validTill,unixTimeStamp);
    
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *validTilldate=[_formatter stringFromDate:date];
    
    [self setServiceCategoryImagesWithMerchant:deal];
    
    self.validTillLabel.text = [NSString stringWithFormat:@"Valid till %@",validTilldate];
    return self;
}

-(void)setServiceCategoryImagesWithMerchant:(Deal *)deal{
    
    NSArray *categoryMap = @[@"merchant-massage",@"merchant-massage",@"merchant-nail",@"merchant-haircut",@"merchant-makeup",@"merchant-face",@"merchant-removal",@"merchant-massage",@"merchant-massage"];
    for(int index = 0;index<8;index++){
        
        NSString *imageName = [NSString stringWithFormat:@"%@.png",categoryMap[index]];
        NSString *selectedImageName = [NSString stringWithFormat:@"%@-deal.png",categoryMap[index]];
        
        switch(index){
            case 0:
                self.serviceCategoryImageView1.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 1:
                self.serviceCategoryImageView2.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 2:
                self.serviceCategoryImageView3.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                
                break;
            case 3:
                self.serviceCategoryImageView4.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                
                break;
            case 4:
                self.serviceCategoryImageView5.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                
                break;
            case 5:
                self.serviceCategoryImageView6.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                
                break;
            case 6:
                self.serviceCategoryImageView7.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                
                break;
            case 7:
                self.serviceCategoryImageView8.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                
                break;
            case 8:
                self.serviceCategoryImageView9.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                
                break;

            default:
                break;
        }
    }
}



@end
