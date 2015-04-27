//
//  DealTimingCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealTimingCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *daysLabel;
@property (nonatomic, weak) IBOutlet UILabel *timingLabel;
@property (nonatomic, weak) IBOutlet UIImageView *rateCardImageview;

-(DealTimingCell *)setupCellWithDeal:(Deal *)deal;

@end
