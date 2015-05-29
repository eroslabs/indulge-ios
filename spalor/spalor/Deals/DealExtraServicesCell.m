//
//  DealExtraServicesCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealExtraServicesCell.h"

@implementation DealExtraServicesCell
-(DealExtraServicesCell *)setupCellWithDeal:(Deal *)deal{
    self.extraservicesLabel.text = (deal.ccAccepted)?@"Credit Cards accepted!":@"Credit Cards NOT accepted";
    return self;
}
@end
