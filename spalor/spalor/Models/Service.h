//
//  Service.h
//  spalor
//
//  Created by Manish on 22/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject
@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSString *categoryId;

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *name;

- (void)readFromDictionary:(NSDictionary *)dictionary;
@end
