//
//  ServiceCategory.h
//  spalor
//
//  Created by Manish on 22/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface ServiceCategory : NSObject<NSCoding>
//Attributes
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *validTill;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;

//Relation
@property (nonatomic, strong) NSMutableArray *services;

- (void)readFromDictionary:(NSDictionary *)dictionary;
@end
