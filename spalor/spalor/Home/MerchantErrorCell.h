//
//  MerchantErrorCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface MerchantErrorCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *reportErrorButton;
-(MerchantErrorCell *)setupWithMerchant:(Merchant *)merchant;

@end
