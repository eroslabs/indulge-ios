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
    NSString *weekSchedule = merchant.schedule.weekSchedule;
    NSMutableString *finalWeekString = [[NSMutableString alloc] initWithString:@""];
    [weekSchedule enumerateSubstringsInRange:[weekSchedule rangeOfString:weekSchedule]
                                  options:NSStringEnumerationByComposedCharacterSequences
                               usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                   if([substring isEqualToString:@"1"]){
                                       switch(substringRange.location){
                                           case 0:
                                               //Sunday
                                               [finalWeekString appendFormat:@"M "];
                                               break;
                                           case 1:
                                               [finalWeekString appendFormat:@"T "];

                                               break;
                                           case 2:
                                               [finalWeekString appendFormat:@"W "];

                                               break;
                                           case 3:
                                               [finalWeekString appendFormat:@"Th "];

                                               break;
                                           case 4:
                                               [finalWeekString appendFormat:@"F "];

                                               break;
                                           case 5:
                                               [finalWeekString appendFormat:@"Sa "];

                                               break;
                                           case 6:
                                               [finalWeekString appendFormat:@"Su "];

                                               break;
                                           default:
                                               break;
                                               
                                       }
                                   }
                               }] ;

    self.daysLabel.text = finalWeekString;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ to %@",merchant.schedule.openingTime,merchant.schedule.closingTime];
    self.ratecardImageView = [UIImage imageNamed:@""];
    return self;
}
@end
