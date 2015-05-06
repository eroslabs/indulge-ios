//
//  ServiceCategory.m
//  spalor
//
//  Created by Manish on 22/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ServiceCategory.h"
#import "Service.h"
#import <objc/runtime.h>

@implementation ServiceCategory

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        self.validTill = [decoder decodeObjectForKey:@"validTill"];
        self.categoryId = [decoder decodeObjectForKey:@"categoryId"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.services = [decoder decodeObjectForKey:@"services"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_validTill forKey:@"validTill"];
    [encoder encodeObject:_categoryId forKey:@"categoryId"];
    [encoder encodeObject:_image forKey:@"image"];
    [encoder encodeObject:_desc forKey:@"desc"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_services forKey:@"services"];

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
        
        if (dictionary[key] && ![dictionary[key] isMemberOfClass:[NSNull class]]) {
            
            if([key isEqualToString:@"id"]){
                self.categoryId = dictionary[key];
            }
            else if([key isEqualToString:@"description"]){
                self.desc = dictionary[key];
            }
            else if ([key isEqualToString:@"services"]) {
                
                //NSLog(@"Services %@",dictionary[key]);
                
                self.services = [[NSMutableArray alloc] init];
                for (NSDictionary *service in dictionary[key]){
                    Service *merchantService = [[Service alloc] init];
                    [merchantService readFromDictionary:service];
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

#pragma mark - Segue



@end
