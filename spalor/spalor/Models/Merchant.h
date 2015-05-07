//
//  Merchant.h
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Schedule.h"
#import "MerchantService.h"
#import "Review.h"
#import "MerchantDeal.h"

@interface Merchant : NSObject<NSCoding>

//Attributes
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ccAccepted;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *genderSupport;
@property (nonatomic, strong) NSString *homeService;
@property (nonatomic, strong) NSString *merchantid;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *landmark;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *pincode;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *separateRateCard;
@property (nonatomic, strong) NSString *serviceRadius;
@property (nonatomic, strong) NSString *software;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *unitNumber;
@property (nonatomic, strong) NSString *luxuryRating;
@property (nonatomic, strong) NSString *distanceFromCurrentLocation;

//Images
@property (nonatomic, strong) NSArray *merchantImageUrls;
@property (nonatomic, strong) NSArray *rateCardImageUrls;

//Relations
@property (nonatomic, strong) Location *geo;
@property (nonatomic, strong) Schedule *schedule;
@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSMutableArray *reviews;
@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, strong) NSMutableArray *weekdaysArray;


//Methods
- (void)readFromDictionary:(NSDictionary *)dictionary;

@end
