//
//  DealDetailsViewController.h
//  spalor
//
//  Created by Manish on 24/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealDetailsViewController : UIViewController
@property (nonatomic, strong) Deal *deal;
@property (nonatomic, weak) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UITextView *redeemTextView;
@property (nonatomic, weak) IBOutlet UIView *acceptRejectView;
@end
