//
//  Services.h
//  spalor
//
//  Created by Manish on 14/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantService : NSObject<NSCoding>
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *serviceId;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *gender;
@end
