//
//  Schedule.h
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject<NSCoding>
@property (nonatomic, strong) NSString *closingTime;
@property (nonatomic, strong) NSString *openingTime;
@property (nonatomic, strong) NSString *weekSchedule;
@end
