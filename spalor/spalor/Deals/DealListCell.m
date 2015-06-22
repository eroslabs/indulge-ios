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
        
        NSString *distanceString = [NSString stringWithFormat:@"%.1f m",deal.distanceFromCurrentLocation.doubleValue];
        if(deal.distanceFromCurrentLocation.doubleValue > 1000){
            distanceString = [NSString stringWithFormat:@"%.1f km",deal.distanceFromCurrentLocation.doubleValue/1000];
        }
        self.distanceLabel.text = distanceString;

        
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
    
    [self setServiceCategoryImagesWithDeal:deal];
    
    self.validTillLabel.text = [NSString stringWithFormat:@"Valid till %@",validTilldate];
    return self;
}

-(void)setServiceCategoryImagesWithDeal:(Deal *)deal{
    
    NSArray *categoryMap = @[@"merchant-massage",@"merchant-makeup",@"merchant-nail",@"merchant-haircut",@"merchant-body",@"merchant-face",@"merchant-removal",@"merchant-pt",@"merchant-combo"];
   
    self.serviceCategoryImageView1.hidden = YES;
    self.serviceCategoryImageView2.hidden = YES;
    self.serviceCategoryImageView3.hidden = YES;
    self.serviceCategoryImageView4.hidden = YES;
    self.serviceCategoryImageView5.hidden = YES;
    self.serviceCategoryImageView6.hidden = YES;
    self.serviceCategoryImageView7.hidden = YES;
    self.serviceCategoryImageView8.hidden = YES;
    self.serviceCategoryImageView9.hidden = YES;
    
    self.serviceNameLabel1.hidden = YES;
    self.serviceNameLabel2.hidden = YES;
    self.serviceNameLabel3.hidden = YES;


    if (deal.services.count>3) {
        int index = 0;
        for (NSNumber *categoryId in deal.categoryIds) {
            int mapVal = categoryId.intValue;
            NSString *imageName = [NSString stringWithFormat:@"%@.png",categoryMap[mapVal]];
            switch(index){
                case 0:{
                    self.serviceCategoryImageView1.hidden = NO;
                    self.serviceCategoryImageView1.image = [UIImage imageNamed:imageName];
                    break;
                }
                case 1:{
                    self.serviceCategoryImageView2.hidden = NO;
                    self.serviceCategoryImageView2.image = [UIImage imageNamed:imageName];
                    break;
                }
                case 2:{
                    self.serviceCategoryImageView3.image = [UIImage imageNamed:imageName];
                    self.serviceCategoryImageView3.hidden = NO;
                    break;
                }
                case 3:{
                    self.serviceCategoryImageView4.image = [UIImage imageNamed:imageName];
                    self.serviceCategoryImageView4.hidden = NO;
                    
                    break;
                }
                case 4:{
                    self.serviceCategoryImageView5.image = [UIImage imageNamed:imageName];
                    self.serviceCategoryImageView5.hidden = NO;
                    
                    break;
                }
                case 5:{
                    self.serviceCategoryImageView6.image = [UIImage imageNamed:imageName];
                    self.serviceCategoryImageView6.hidden = NO;
                    
                    break;
                }
                case 6:{
                    self.serviceCategoryImageView7.image = [UIImage imageNamed:imageName];
                    self.serviceCategoryImageView7.hidden = NO;
                    
                    break;
                }
                case 7:{
                    self.serviceCategoryImageView8.image = [UIImage imageNamed:imageName];
                    self.serviceCategoryImageView8.hidden = NO;
                    
                    break;
                }
                case 8:{
                    self.serviceCategoryImageView9.image = [UIImage imageNamed:imageName];
                    self.serviceCategoryImageView9.hidden = NO;
                    break;
                }
                    
                default:
                    break;
            }
            index++;
            
        }

    }
    else{
        int index = 0;
        for (NSString *string in deal.serviceNames) {
            index++;
            switch (index) {
                case 1:{
                    self.serviceNameLabel1.hidden = NO;
                    self.serviceNameLabel1.text = deal.serviceNames[index-1];
                    break;
                }
                case 2:{
                    self.serviceNameLabel2.hidden = NO;
                    self.serviceNameLabel2.text = deal.serviceNames[index-1];
                    break;
                }
                case 3:{
                    self.serviceNameLabel3.hidden = NO;
                    self.serviceNameLabel3.text = deal.serviceNames[index-1];
                    break;
                }
                default:
                    break;
            }
        }
    }
    
    
//    for(int index = 0;index<8;index++){
//        
//        NSString *imageName = [NSString stringWithFormat:@"%@.png",categoryMap[index]];
//        NSString *selectedImageName = [NSString stringWithFormat:@"%@-deal.png",categoryMap[index]];
//        
//        switch(index){
//            case 0:{
//                self.serviceCategoryImageView1.hidden = NO;
//                self.serviceCategoryImageView1.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                break;
//            }
//            case 1:
//                self.serviceCategoryImageView2.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                break;
//            case 2:
//                self.serviceCategoryImageView3.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                
//                break;
//            case 3:
//                self.serviceCategoryImageView4.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                
//                break;
//            case 4:
//                self.serviceCategoryImageView5.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                
//                break;
//            case 5:
//                self.serviceCategoryImageView6.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                
//                break;
//            case 6:
//                self.serviceCategoryImageView7.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                
//                break;
//            case 7:
//                self.serviceCategoryImageView8.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                
//                break;
//            case 8:
//                self.serviceCategoryImageView9.image = ([deal.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
//                
//                break;
//
//            default:
//                break;
//        }
//    }
}



@end
