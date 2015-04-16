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
#import "Services.h"

@interface Merchant : NSObject

//Attributes
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ccAccepted;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fulladdress;
@property (nonatomic, strong) NSString *genderSupport;
@property (nonatomic, strong) NSString *homeServices;
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

//Images
@property (nonatomic, strong) NSArray *merchantImageUrls;
@property (nonatomic, strong) NSArray *rateCardImageUrls;

//Relations
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Schedule *schedule;
@property (nonatomic, strong) NSMutableArray *servicesArray;

//Methods
- (void)readFromDictionary:(NSDictionary *)dictionary;

@end