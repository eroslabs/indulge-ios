//
//  MerchantScheduleCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface MerchantScheduleCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *daysLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *ratecardImageView;

-(MerchantScheduleCell *)setupWithMerchant:(Merchant *)merchant;

@end
