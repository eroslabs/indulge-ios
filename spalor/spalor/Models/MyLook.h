//
//  MyLook.h
//  spalor
//
//  Created by Manish on 15/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Merchant.h"

@interface MyLook : NSObject
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantAddress;
@property (nonatomic, strong) NSString *merchantRating;
@property (nonatomic, strong) NSString *merchantService;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Merchant *merchant;
@end
