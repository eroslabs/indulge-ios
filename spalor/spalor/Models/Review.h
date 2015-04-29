//
//  Review.h
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject<NSCoding>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *merchantId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *name;

- (void)readFromDictionary:(NSDictionary *)dictionary;

@end
