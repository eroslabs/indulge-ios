//
//  MerchantScheduleCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantScheduleCell.h"
#import "Schedule.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation MerchantScheduleCell
-(MerchantScheduleCell *)setupWithMerchant:(Merchant *)merchant{
    NSString *weekSchedule = merchant.finalWeekSchedule;
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
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday]-1;
    SEL sel = @selector(characterAtIndex:);
    
    // using typeof to save my fingers from typing more
    
    self.timeLabel.text = @"CLOSED";
    
    for (Schedule *schedule in merchant.schedule) {
        unichar (*charAtIdx)(id, SEL, NSUInteger) = (typeof(charAtIdx)) [schedule.weekSchedule methodForSelector:sel];
        
        for (int i = 0; i < schedule.weekSchedule.length; i++) {
            unichar c = charAtIdx(schedule.weekSchedule, sel, i);
            // do something with C
            NSLog(@"%C", c);
            if ((c == '1') && i== weekday) {
                NSArray *openingTime = [schedule.openingTime componentsSeparatedByString:@":"];
                NSString *openingHrsString = openingTime[0];
                
                NSArray *closingTime = [schedule.closingTime componentsSeparatedByString:@":"];
                NSString *closingHrsString = closingTime[0];
                
                NSString *openingTimeString = (openingHrsString.intValue > 12)?[NSString stringWithFormat:@"%d:%@ PM",openingHrsString.intValue-12,openingTime[1]]:[NSString stringWithFormat:@"%@:%@ AM",openingTime[0],openingTime[1]];
                
                NSString *closingTimeString = (closingHrsString.intValue > 12)?[NSString stringWithFormat:@"%d:%@ PM",closingHrsString.intValue-12,closingTime[1]]:[NSString stringWithFormat:@"%@:%@ AM",closingTime[0],closingTime[1]];
                self.timeLabel.text = [NSString stringWithFormat:@"%@ to %@",openingTimeString,closingTimeString];
                break;

            }
            
        }
    }
    if (merchant.menus.count>0) {
        NSString *url = [NSURL URLWithString:merchant.menus[0]];
        [self.ratecardImageView setImageWithURL:url
                               placeholderImage:[UIImage imageNamed:@"welcome.png"] options:SDWebImageProgressiveDownload ];

    }
    else{
        if (merchant.services.count > 0) {
            self.ratecardImageView.image = [UIImage imageNamed:@"welcome.png"];
        }
    }

    return self;
}
@end
