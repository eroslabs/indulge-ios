//
//  Deal.m
//  spalor
//
//  Created by Manish on 20/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Deal.h"
#import <objc/runtime.h>
#import "LocationHelper.h"

@implementation Deal

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
    
        self.validTill = [decoder decodeObjectForKey:@"validTill"];
        self.recommendedService = [decoder decodeObjectForKey:@"recommendedService"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.ccAccepted = [decoder decodeObjectForKey:@"ccAccepted"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.services = [decoder decodeObjectForKey:@"services"];
        self.dealId = [decoder decodeObjectForKey:@"dealId"];
        self.flatOff = [decoder decodeObjectForKey:@"flatOff"];
        self.country = [decoder decodeObjectForKey:@"country"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.genderSupport = [decoder decodeObjectForKey:@"genderSupport"];
        self.merchantid = [decoder decodeObjectForKey:@"merchantid"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.pincode = [decoder decodeObjectForKey:@"pincode"];
        self.rating = [decoder decodeObjectForKey:@"rating"];
        self.percentOff = [decoder decodeObjectForKey:@"percentOff"];
        self.geo = [decoder decodeObjectForKey:@"geo"];
        self.schedule = [decoder decodeObjectForKey:@"schedule"];
        self.couponCode = [decoder decodeObjectForKey:@"couponcode"];
        self.homeService = [decoder decodeObjectForKey:@"homeService"];
        self.distanceFromCurrentLocation = [decoder decodeObjectForKey:@"distanceFromCurrentLocation"];
        self.luxuryRating = [decoder decodeObjectForKey:@"luxuryRating"];
        self.serviceNames = [decoder decodeObjectForKey:@"serviceNames"];
        self.categoryIds = [decoder decodeObjectForKey:@"categoryIds"];
        self.finalWeekSchedule = [decoder decodeObjectForKey:@"finalWeekSchedule"];
        self.menus = [decoder decodeObjectForKey:@"menus"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_validTill forKey:@"validTill"];
    [encoder encodeObject:_recommendedService forKey:@"recommendedService"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_image forKey:@"image"];
    [encoder encodeObject:_ccAccepted forKey:@"ccAccepted"];
    [encoder encodeObject:_services forKey:@"services"];
    [encoder encodeObject:_dealId forKey:@"dealId"];
    [encoder encodeObject:_flatOff forKey:@"flatOff"];
    [encoder encodeObject:_country forKey:@"country"];
    [encoder encodeObject:_email forKey:@"email"];
    [encoder encodeObject:_address forKey:@"address"];
    [encoder encodeObject:_genderSupport forKey:@"genderSupport"];
    [encoder encodeObject:_merchantid forKey:@"merchantid"];
    [encoder encodeObject:_phone forKey:@"phone"];
    [encoder encodeObject:_pincode forKey:@"pincode"];
    [encoder encodeObject:_rating forKey:@"rating"];
    [encoder encodeObject:_percentOff forKey:@"percentOff"];
    [encoder encodeObject:_geo forKey:@"geo"];
    [encoder encodeObject:_schedule forKey:@"schedule"];
    [encoder encodeObject:_couponCode forKey:@"couponcode"];
    [encoder encodeObject:_homeService forKey:@"homeService"];
    [encoder encodeObject:_luxuryRating forKey:@"luxuryRating"];
    [encoder encodeObject:_categoryIds forKey:@"categoryIds"];
    [encoder encodeObject:_serviceNames forKey:@"serviceNames"];
    [encoder encodeObject:_finalWeekSchedule forKey:@"finalWeekSchedule"];
    [encoder encodeObject:_distanceFromCurrentLocation forKey:@"distanceFromCurrentLocation"];
    [encoder encodeObject:_menus forKey:@"menus"];
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
    
    if ([[dictionary allKeys] containsObject:@"days"]){
        self.weekdaysArray = [NSMutableArray new];
        
        for (int i=0; i < [dictionary[@"days"] length]; i++) {
            NSString *ichar  = [NSString stringWithFormat:@"%c", [dictionary[@"days"] characterAtIndex:i]];
            if ([ichar isEqualToString:@"1"]) {
                [self.weekdaysArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        self.finalWeekSchedule = dictionary[@"days"];
    }

    self.recommendedService = @"";
    
    for (NSString *key in allProps){
        
        //NSLog(@"KEY %@",key);
        if ([key isEqualToString:@"dealId"]) {
            [self setValue:dictionary[@"id"] forKey:key];
        }
        
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
            else if ([key isEqualToString:@"services"]) {
                self.services = [[NSMutableArray alloc] init];
                for (NSDictionary *service in dictionary[key]){
                    MerchantService *merchantService = [[MerchantService alloc] init];
                    merchantService.serviceId = service[@"id"];
                    merchantService.name = service[@"name"];
                    merchantService.categoryId = service[@"categoryId"];
                    merchantService.desc = service[@"description"];
                    merchantService.price = service[@"price"];
                    merchantService.image = service[@"image"];
                    [self.services addObject:merchantService];
                }
            }
            else if ([key isEqualToString:@"schedule"]) {
                
                self.schedule = [NSMutableArray new];
                for (NSDictionary *scheduleObj in dictionary[key]) {
                    Schedule *object = [[Schedule alloc] init];
                    object.openingTime = [scheduleObj objectForKey:@"openingTime"];
                    object.closingTime = [scheduleObj objectForKey:@"closingTime"];
                    object.weekSchedule = [scheduleObj objectForKey:@"weekSchedule"];
                    [self.schedule addObject:object];
                    
                }
                
                //                [self setValue:schedule forKey:key];
            }

            else if([key isEqualToString:@"validTill"]){
                NSString *string = [dictionary[key] stringValue];
                if ([string length] > 3) {
                    string = [string substringToIndex:[string length] - 3];
                }
                [self setValue:string forKey:key];
            }
            else if ([key isEqualToString:@"menus"]){
                self.menus = [NSMutableArray new];
                for (NSDictionary *menuObj in dictionary[key]) {
                    [self.menus addObject:[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,menuObj[@"image"]]];
                }
            }
            else if (![dictionary[key] isKindOfClass:[NSString class]] && ![dictionary[key] isKindOfClass:[NSArray class]]) {
                [self setValue:[dictionary[key] stringValue] forKey:key];
            }
            else{
                [self setValue:dictionary[key] forKey:key];
            }
        }
    }
}
@end
