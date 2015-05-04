//
//  MerchantDeal.m
//  spalor
//
//  Created by Manish on 20/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantDeal.h"

@implementation MerchantDeal
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.amountOff = [decoder decodeObjectForKey:@"amountOff"];
        self.services = [decoder decodeObjectForKey:@"services"];
        
        self.validTill = [decoder decodeObjectForKey:@"validTill"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_amountOff forKey:@"amountOff"];
    [encoder encodeObject:_services forKey:@"services"];
    [encoder encodeObject:_validTill forKey:@"validTill"];
    
}
@end
