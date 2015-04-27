//
//  MerchantSocialCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface MerchantSocialCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIButton *callButton;
@property (nonatomic,weak) IBOutlet UIButton *locationButton;
@property (nonatomic,weak) IBOutlet UIButton *shareButton;
@property (nonatomic,weak) IBOutlet UIButton *favoriteButton;

-(MerchantSocialCell *)setupWithMerchant:(Merchant *)merchant;

@end
