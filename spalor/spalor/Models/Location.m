//
//  Location.m
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Location.h"

@implementation Location

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.lon = [decoder decodeObjectForKey:@"lon"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_lat forKey:@"lat"];
    [encoder encodeObject:_lon forKey:@"lon"];
    
}


@end
