//
//  Deal.h
//  spalor
//
//  Created by Manish on 20/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Schedule.h"
#import "MerchantService.h"

@interface Deal : NSObject<NSCoding>
//Attributes
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ccAccepted;
@property (nonatomic, strong) NSString *dealId;
@property (nonatomic, strong) NSString *flatOff;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *genderSupport;
@property (nonatomic, strong) NSString *merchantid;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *pincode;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *validTill;
@property (nonatomic, strong) NSString *percentOff;
@property (nonatomic, strong) NSString *amountOff;
@property (nonatomic, strong) NSString *couponCode;


//Relations
@property (nonatomic, strong) Location *geo;
@property (nonatomic, strong) NSMutableArray *services;

//Methods
- (void)readFromDictionary:(NSDictionary *)dictionary;

@end
