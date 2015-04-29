//
//  Schedule.m
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.closingTime = [decoder decodeObjectForKey:@"closingTime"];
        self.openingTime = [decoder decodeObjectForKey:@"openingTime"];
        self.weekSchedule = [decoder decodeObjectForKey:@"weekSchedule"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_closingTime forKey:@"closingTime"];
    [encoder encodeObject:_openingTime forKey:@"openingTime"];
    [encoder encodeObject:_weekSchedule forKey:@"weekSchedule"];

}
@end
