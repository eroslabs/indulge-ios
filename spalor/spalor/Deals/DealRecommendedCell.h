//
//  DealRecommendedCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealRecommendedCell : UITableViewCell
-(DealRecommendedCell *)setupCellWithDeal:(Deal *)deal;
@end
