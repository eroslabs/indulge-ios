//
//  Review.m
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Review.h"
#import <objc/objc-runtime.h>

@implementation Review
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
        
        if (dictionary[key] && ![dictionary[key] isMemberOfClass:[NSNull class]]) {
            if (![dictionary[key] isKindOfClass:[NSString class]]) {
                [self setValue:[dictionary[key] stringValue] forKey:key];
            }
            else{
                [self setValue:dictionary[key] forKey:key];
            }
        }
        else{
            [self setValue:dictionary[key] forKey:key];
        }
        // }
    }
}

@end
