//
//  Merchant.m
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Merchant.h"
#import <objc/runtime.h>



@implementation Merchant

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
    
    for (NSString *key in allProps){
        
        NSLog(@"KEY %@",key);
        
        if (dictionary[key] && ![dictionary[key] isMemberOfClass:[NSNull class]]) {
            
            if ([key isEqualToString:@"geo"]) {
                Location *location = [[Location alloc] init];
                location.lat = [dictionary[key] objectForKey:@"lat"];
                location.lon = [dictionary[key] objectForKey:@"lon"];
                [self setValue:location forKey:key];
            }
            else if ([key isEqualToString:@"schedule"]) {
                Schedule *schedule = [[Schedule alloc] init];
                schedule.openingTime = [dictionary[key] objectForKey:@"openingTime"];
                schedule.closingTime = [dictionary[key] objectForKey:@"closingTime"];
                schedule.weekSchedule = [dictionary[key] objectForKey:@"weekSchedule"];
                [self setValue:schedule forKey:key];
            }
            else if ([key isEqualToString:@"services"]) {
                self.services = [[NSMutableArray alloc] init];
                for (NSDictionary *service in dictionary[key]){
                    MerchantService *merchantService = [[MerchantService alloc] init];
                    merchantService.serviceId = service[@"id"];
                    merchantService.desc = service[@"description"];
                    merchantService.price = service[@"price"];
                    merchantService.image = service[@"image"];
                    merchantService.categoryId = service[@"categoryId"];
                    [self.services addObject:merchantService];
                }
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
