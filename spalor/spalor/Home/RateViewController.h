//
//  RateViewController.h
//  spalor
//
//  Created by Manish on 27/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateViewController : UITableViewController
@property NSString *merchantId;
@property (nonatomic, weak) IBOutlet UISlider *overallSlider;
@property (nonatomic, weak) IBOutlet UISlider *cleanlinessSlider;
@property (nonatomic, weak) IBOutlet UISlider *serviceQualitySlider;
@property (nonatomic, weak) IBOutlet UITextView *commentTextView;
@property (nonatomic , weak) IBOutlet UIView *loaderContainerView;

@end
