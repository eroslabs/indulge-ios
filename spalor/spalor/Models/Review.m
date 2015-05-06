//
//  Review.m
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Review.h"
#import <objc/runtime.h>

@implementation Review

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.merchantId = [decoder decodeObjectForKey:@"merchantId"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.rating = [decoder decodeObjectForKey:@"rating"];
        self.name = [decoder decodeObjectForKey:@"name"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_merchantId forKey:@"merchantId"];
    [encoder encodeObject:_text forKey:@"text"];
    [encoder encodeObject:_rating forKey:@"rating"];
    [encoder encodeObject:_name forKey:@"name"];
    
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
