//
//  MerchantExtrasCell.h
//  spalor
//
//  Created by Manish on 27/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface MerchantExtrasCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *extrasLabel;
@property (nonatomic, weak) IBOutlet UIImageView *extrasImageView;
-(MerchantExtrasCell *)setupWithMerchant:(Merchant *)merchant;

@end
