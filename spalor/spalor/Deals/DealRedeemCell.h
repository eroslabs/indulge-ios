//
//  DealRedeemCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealRedeemCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *redeemButton;

-(DealRedeemCell *)setupCellWithDeal:(Deal *)deal;
@end
