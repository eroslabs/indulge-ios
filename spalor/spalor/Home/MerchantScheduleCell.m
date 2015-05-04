//
//  MerchantScheduleCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantScheduleCell.h"

@implementation MerchantScheduleCell
-(MerchantScheduleCell *)setupWithMerchant:(Merchant *)merchant{
    self.daysLabel.text = merchant.schedule.weekSchedule;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ to %@",merchant.schedule.openingTime,merchant.schedule.closingTime];
    self.ratecardImageView = [UIImage imageNamed:@""];
    return self;
}
@end
