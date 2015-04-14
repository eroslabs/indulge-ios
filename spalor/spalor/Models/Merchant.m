//
//  Merchant.m
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Merchant.h"
#define NAMEKEY @""
#define
@implementation Merchant
- (void)readFromDictionary:(NSDictionary *)dictionary{
    
    if (dictionary[NAMEKEY] && ![dictionary[NAMEKEY] isMemberOfClass:[NSNull class]]) {
        //self.name = [NSString stringWithFormat:@"%@",dictionary[NAMEKEY]];
        self.name = dictionary[NAMEKEY];
    }
    

    
}
@end
