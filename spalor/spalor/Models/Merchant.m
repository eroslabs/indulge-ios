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
        self.geo = [decoder decodeObjectForKey:@"geo"];
        self.services = [decoder decodeObjectForKey:@"services"];
        self.reviews = [decoder decodeObjectForKey:@"reviews"];
        self.deals = [decoder decodeObjectForKey:@"deals"];
        self.weekdaysArray = [decoder decodeObjectForKey:@"weekdaysArray"];
        self.merchantImageUrls = [decoder decodeObjectForKey:@"merchantImageUrls"];
        self.distanceFromCurrentLocation = [decoder decodeObjectForKey:@"distanceFromCurrentLocation"];
        self.luxuryRating = [decoder decodeObjectForKey:@"luxuryRating"];
        self.schedule = [decoder decodeObjectForKey:@"schedules"];
        self.finalWeekSchedule = [decoder decodeObjectForKey:@"finalWeekString"];
        self.categoryIds = [decoder decodeObjectForKey:@"categoryIds"];
        self.serviceNames = [decoder decodeObjectForKey:@"serviceNames"];

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
    [encoder encodeObject:_services forKey:@"services"];
    [encoder encodeObject:_reviews forKey:@"reviews"];
    [encoder encodeObject:_deals forKey:@"deals"];
    [encoder encodeObject:_image forKey:@"image"];
    [encoder encodeObject:_weekdaysArray];
    [encoder encodeObject:_distanceFromCurrentLocation forKey:@"distanceFromCurrentLocation"];
    [encoder encodeObject:_luxuryRating forKey:@"luxuryRating"];
    [encoder encodeObject:_schedule forKey:@"schedules"];
    [encoder encodeObject:_finalWeekSchedule forKey:@"finalWeekString"];
    [encoder encodeObject:_categoryIds forKey:@"categoryIds"];
    [encoder encodeObject:_serviceNames forKey:@"serviceNames"];

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
    if (![[dictionary allKeys] containsObject:@"luxuryRating"]) {
        int rndValue = 1 + arc4random() % (4 - 1);
        
        self.luxuryRating = [NSString stringWithFormat:@"%d",rndValue];
    }
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
    
    self.image = @"";
    self.merchantImageUrls = [[NSMutableArray alloc] init];
    
    if (dictionary[@"id"] && ![dictionary[@"id"] isMemberOfClass:[NSNull class]]) {
        self.merchantid = dictionary[@"id"];
    }
    
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
            else if ([key isEqualToString:@"finalWeekSchedule"]){
                self.weekdaysArray = [NSMutableArray new];
                
                for (int i=0; i < [dictionary[key] length]; i++) {
                    NSString *ichar  = [NSString stringWithFormat:@"%c", [dictionary[key] characterAtIndex:i]];
                    if ([ichar isEqualToString:@"1"]) {
                        [self.weekdaysArray addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                }
                self.finalWeekSchedule = dictionary[@"finalWeekSchedule"];
            }
            else if ([key isEqualToString:@"schedule"]) {
                                
                self.schedule = [NSMutableArray new];
                for (NSDictionary *scheduleObj in dictionary[key]) {
                    Schedule *schedule = [[Schedule alloc] init];
                    schedule.openingTime = [scheduleObj objectForKey:@"openingTime"];
                    schedule.closingTime = [scheduleObj objectForKey:@"closingTime"];
                    schedule.weekSchedule = [scheduleObj objectForKey:@"weekSchedule"];
                    
                    [self.schedule addObject:schedule];

                }
                
//                [self setValue:schedule forKey:key];
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
                    Deal *deal = [[Deal alloc] init];
//                    deal.flatOff = dealObject[@"flatOff"];
//                    deal.percentOff = dealObject[@"percentOff"];
//                    deal.services = [dealObject[@"service"] objectForKey:@"description"];
//                    NSString *string = [dealObject[@"validTill"] stringValue];
//                    if ([string length] > 3) {
//                        string = [string substringToIndex:[string length] - 3];
//                    }
//                    deal.validTill = string;
                    [deal readFromDictionary:dealObject];
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
            else if ([key isEqualToString:@"merchantImageUrls"]) {
                for (NSString *imageURL in dictionary[@"images"]){
                    [self.merchantImageUrls addObject:imageURL];
                }

            }
            else if (![dictionary[key] isKindOfClass:[NSString class]] &&![dictionary[key] isKindOfClass:[NSArray class]]) {
                [self setValue:[dictionary[key] stringValue] forKey:key];
            }
            else{
                [self setValue:dictionary[key] forKey:key];

            }
        }
    }
}
@end
