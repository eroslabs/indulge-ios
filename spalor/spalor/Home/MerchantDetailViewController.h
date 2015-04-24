//
//  MerchantDetailViewController.h
//  spalor
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface MerchantDetailViewController : UIViewController
@property (nonatomic,strong) Merchant *merchant;
-(IBAction)goBack:(id)sender;
@end
