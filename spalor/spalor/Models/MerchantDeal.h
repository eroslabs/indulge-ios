//
//  MerchantDeal.h
//  spalor
//
//  Created by Manish on 20/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantDeal : NSObject<NSCoding>
@property (nonatomic, strong) NSString *amountOff;
@property (nonatomic, strong) NSString *services;
@property (nonatomic, strong) NSString *validTill;
@end
