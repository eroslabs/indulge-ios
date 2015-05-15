//
//  RedeemDealViewController.h
//  spalor
//
//  Created by Manish on 27/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface RedeemDealViewController : UIViewController
@property NSString *couponCode;
@property (nonatomic, strong) Deal *deal;
@property (nonatomic, weak) IBOutlet UILabel *couponCodeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *couponQRCodeImageView;

@end
