//
//  Services.m
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantService.h"

@implementation MerchantService
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.serviceId = [decoder decodeObjectForKey:@"openingTime"];
        self.categoryId = [decoder decodeObjectForKey:@"categoryId"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.image = [decoder decodeObjectForKey:@"image"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_desc forKey:@"desc"];
    [encoder encodeObject:_serviceId forKey:@"serviceId"];
    [encoder encodeObject:_categoryId forKey:@"categoryId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_price forKey:@"price"];
    [encoder encodeObject:_image forKey:@"image"];
    
}
@end
