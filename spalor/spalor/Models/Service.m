//
//  Service.m
//  spalor
//
//  Created by Manish on 22/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Service.h"
#import <objc/objc-runtime.h>

@implementation Service
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
        
        //NSLog(@"KEY %@",key);
        
        //if (dictionary[key] && ![dictionary[key] isMemberOfClass:[NSNull class]]) {
            
            if([key isEqualToString:@"serviceId"] && ![dictionary[@"id"] isMemberOfClass:[NSNull class]]){
                self.serviceId = [dictionary[@"id"] stringValue];
            }
            else if([key isEqualToString:@"desc"] && ![dictionary[@"desc"] isMemberOfClass:[NSNull class]]){
                self.desc = dictionary[@"description"];
            }
            else if (![dictionary[key] isKindOfClass:[NSString class]] && ![dictionary[key] isMemberOfClass:[NSNull class]]) {
                [self setValue:[dictionary[key] stringValue] forKey:key];
            }
            else{
                [self setValue:dictionary[key] forKey:key];
            }
       // }
    }
}

@end