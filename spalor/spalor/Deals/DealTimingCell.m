//
//  DealTimingCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealTimingCell.h"

@implementation DealTimingCell
-(DealTimingCell *)setupCellWithDeal:(Deal *)deal{
    NSString *weekSchedule = deal.schedule.weekSchedule;
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
    self.timingLabel.text = [NSString stringWithFormat:@"%@ to %@",deal.schedule.openingTime,deal.schedule.closingTime];
    //self.rateCardImageview.image = [UIImage imageNamed:@""];
    return self;
}

@end
