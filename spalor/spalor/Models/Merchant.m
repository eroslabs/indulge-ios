//
//  Merchant.m
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Merchant.h"
#import <objc/runtime.h>
#import "LocationHelper.h"


@implementation Merchant

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.ccAccepted = [decoder decodeObjectForKey:@"ccAccepted"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.country = [decoder decodeObjectForKey:@"country"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.genderSupport = [decoder decodeObjectForKey:@"genderSupport"];
        self.homeService = [decoder decodeObjectForKey:@"homeService"];
        self.merchantid = [decoder decodeObjectForKey:@"merchantid"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.pincode = [decoder decodeObjectForKey:@"pincode"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.rating = [decoder decodeObjectForKey:@"rating"];
        self.separateRateCard = [decoder decodeObjectForKey:@"separateRateCard"];
        self.serviceRadius = [decoder decodeObjectForKey:@"serviceRadius"];
        self.software = [decoder decodeObjectForKey:@"software"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.unitNumber = [decoder decodeObjectForKey:@"unitNumber"];
        self.merchantImageUrls = [decoder decodeObjectForKey:@"merchantImageUrls"];
        self.geo = [decoder decodeObjectForKey:@"geo"];
        self.schedule = [decoder decodeObjectForKey:@"schedule"];
        self.services = [decoder decodeObjectForKey:@"services"];
        self.reviews = [decoder decodeObjectForKey:@"reviews"];
        self.deals = [decoder decodeObjectForKey:@"deals"];
        self.weekdaysArray = [decoder decodeObjectForKey:@"weekdaysArray"];
        self.distanceFromCurrentLocation = [decoder decodeObjectForKey:@"distanceFromCurrentLocation"];
        self.luxuryRating = [decoder decodeObjectForKey:@"luxuryRating"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_ccAccepted forKey:@"ccAccepted"];
    [encoder encodeObject:_city forKey:@"city"];
    [encoder encodeObject:_country forKey:@"country"];
    [encoder encodeObject:_email forKey:@"email"];
    [encoder encodeObject:_address forKey:@"address"];
    [encoder encodeObject:_genderSupport forKey:@"genderSupport"];
    [encoder encodeObject:_homeService forKey:@"homeService"];
    [encoder encodeObject:_merchantid forKey:@"merchantid"];
    [encoder encodeObject:_pincode forKey:@"pincode"];
    [encoder encodeObject:_rating forKey:@"rating"];
    [encoder encodeObject:_separateRateCard forKey:@"separateRateCard"];
    [encoder encodeObject:_serviceRadius forKey:@"serviceRadius"];
    [encoder encodeObject:_software forKey:@"software"];
    [encoder encodeObject:_unitNumber forKey:@"unitNumber"];
    [encoder encodeObject:_merchantImageUrls forKey:@"merchantImageUrls"];
    [encoder encodeObject:_geo forKey:@"geo"];
    [encoder encodeObject:_schedule forKey:@"schedule"];
    [encoder encodeObject:_services forKey:@"services"];
    [encoder encodeObject:_reviews forKey:@"reviews"];
    [encoder encodeObject:_deals forKey:@"deals"];
    [encoder encodeObject:_weekdaysArray];
    [encoder encodeObject:_distanceFromCurrentLocation forKey:@"distanceFromCurrentLocation"];
    [encoder encodeObject:_luxuryRating forKey:@"luxuryRating"];
}

- (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}



- (void)readFromDictionary:(NSDictionary *)dictionary{
    
    NSArray *allProps = [self allPropertyNames];
    
    //if (![allProps containsObject:@"reviews"]) {
        //Add a dummy review
        
        NSDictionary *dummyReview = @{@"userId":@"1",@"merchantId":@"1",@"text":@"This is a good review",@"rating":@"3.5",@"name":@"manish"};
        self.reviews = [[NSMutableArray alloc] init];
        //for (NSDictionary *reviewObject in dictionary[key]){
            Review *review = [[Review alloc] init];
            [review readFromDictionary:dummyReview];
        NSLog(@"review %@ %@ %@ %@ %@",review.name,review.userId,review.merchantId,review.rating,review.text);
            [self.reviews addObject:review];
        //}
    //}
    
    for (NSString *key in allProps){
        
        //NSLog(@"KEY %@",key);
        
        if (dictionary[key] && ![dictionary[key] isMemberOfClass:[NSNull class]]) {
            
            if ([key isEqualToString:@"geo"]) {
                Location *location = [[Location alloc] init];
                location.lat = [dictionary[key] objectForKey:@"lat"];
                location.lon = [dictionary[key] objectForKey:@"lon"];
                CLLocation *merchantlocation = [[CLLocation alloc] initWithLatitude:location.lat.floatValue longitude:location.lon.floatValue];
                double distanceofmerchant = [[LocationHelper sharedInstance] distanceInmeteresFrom:merchantlocation];
                
                if(distanceofmerchant == -1.0){
                    self.distanceFromCurrentLocation = [NSString stringWithFormat:@"0"];

                }
                else{
                    self.distanceFromCurrentLocation = [NSString stringWithFormat:@"%.2f",distanceofmerchant];
                }
                
                [self setValue:location forKey:key];
            }
            else if ([key isEqualToString:@"schedule"]) {
                Schedule *schedule = [[Schedule alloc] init];
                schedule.openingTime = [dictionary[key] objectForKey:@"openingTime"];
                schedule.closingTime = [dictionary[key] objectForKey:@"closingTime"];
                schedule.weekSchedule = [dictionary[key] objectForKey:@"weekSchedule"];
                
                self.weekdaysArray = [NSMutableArray new];
                
                for (int i=0; i < [schedule.weekSchedule length]; i++) {
                    NSString *ichar  = [NSString stringWithFormat:@"%c", [schedule.weekSchedule characterAtIndex:i]];
                    if ([ichar isEqualToString:@"1"]) {
                        [self.weekdaysArray addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                }
                
                [self setValue:schedule forKey:key];
            }
            else if ([key isEqualToString:@"services"]) {
                self.services = [[NSMutableArray alloc] init];
                for (NSDictionary *service in dictionary[key]){
                    MerchantService *merchantService = [[MerchantService alloc] init];
                    merchantService.serviceId = service[@"id"];
                    merchantService.desc = service[@"description"];
                    merchantService.name = service[@"name"];
                    merchantService.price = service[@"price"];
                    merchantService.image = service[@"image"];
                    merchantService.categoryId = service[@"categoryId"];
                    [self.services addObject:merchantService];
                }
            }
            else if ([key isEqualToString:@"deals"]) {
                self.deals = [[NSMutableArray alloc] init];
                for (NSDictionary *dealObject in dictionary[key]){
                    MerchantDeal *deal = [[MerchantDeal alloc] init];
                    deal.flatOff = dealObject[@"flatOff"];
                    deal.percentOff = dealObject[@"percentOff"];
                    deal.services = [dealObject[@"service"] objectForKey:@"description"];
                    NSString *string = [dealObject[@"validTill"] stringValue];
                    if ([string length] > 3) {
                        string = [string substringToIndex:[string length] - 3];
                    }
                    deal.validTill = string;
                    [self.deals addObject:deal];
                }
            }

            else if ([key isEqualToString:@"reviews"]) {
//                self.reviews = [[NSMutableArray alloc] init];
//                for (NSDictionary *reviewObject in dictionary[key]){
//                    Review *review = [[Review alloc] init];
//                    [review readFromDictionary:reviewObject];
//                    [self.reviews addObject:review];
//                }
            }
            else if (![dictionary[key] isKindOfClass:[NSString class]]) {
                [self setValue:[dictionary[key] stringValue] forKey:key];
            }
            else{
                [self setValue:dictionary[key] forKey:key];

            }
        }
    }
}
@end
