//
//  DealExtraServicesCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealExtraServicesCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *extraservicesLabel;
@property (nonatomic, weak) IBOutlet UIImageView *extraServicesImageView;

-(DealExtraServicesCell *)setupCellWithDeal:(Deal *)deal;
@end
