//
//  DealTimingCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealTimingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DealTimingCell
-(DealTimingCell *)setupCellWithDeal:(Deal *)deal{
    NSString *weekSchedule = deal.finalWeekSchedule;
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

    self.timingLabel.text = @"CLOSED";
    
    for (Schedule *schedule in deal.schedule) {
        unichar (*charAtIdx)(id, SEL, NSUInteger) = (typeof(charAtIdx)) [schedule.weekSchedule methodForSelector:sel];

        for (int i = 0; i < schedule.weekSchedule.length; i++) {
            unichar c = charAtIdx(schedule.weekSchedule, sel, i);
            // do something with C
            DLog(@"%C", c);
            if ((c == '1') && i== weekday) {
                NSArray *openingTime = [schedule.openingTime componentsSeparatedByString:@":"];
                NSString *openingHrsString = openingTime[0];
                
                NSArray *closingTime = [schedule.closingTime componentsSeparatedByString:@":"];
                NSString *closingHrsString = closingTime[0];
                
                NSString *openingTimeString = (openingHrsString.intValue > 12)?[NSString stringWithFormat:@"%d:%@ PM",openingHrsString.intValue-12,openingTime[1]]:[NSString stringWithFormat:@"%@:%@ AM",openingTime[0],openingTime[1]];
                
                NSString *closingTimeString = (closingHrsString.intValue > 12)?[NSString stringWithFormat:@"%d:%@ PM",closingHrsString.intValue-12,closingTime[1]]:[NSString stringWithFormat:@"%@:%@ AM",closingTime[0],closingTime[1]];
                self.timingLabel.text = [NSString stringWithFormat:@"%@ to %@",openingTimeString,closingTimeString];
                break;

            }
        
        }
    }

    if (deal.menus.count>0) {
        NSString *url = [NSURL URLWithString:deal.menus[0]];
        [self.rateCardImageview setImageWithURL:url
                               placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload ];
        
    }

    //self.rateCardImageview.image = [UIImage imageNamed:@""];
    return self;
}

@end
