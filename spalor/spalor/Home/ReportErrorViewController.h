//
//  ReportErrorViewController.h
//  spalor
//
//  Created by Manish on 27/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ReportErrorViewController : UITableViewController
@property NSString *merchantId;
@property (nonatomic, weak)IBOutlet UIButton *wrongPhoneButton;
@property (nonatomic, weak)IBOutlet UIButton *wrongAddressButton;
@property (nonatomic, weak)IBOutlet UIButton *closedClosedButton;
@property (nonatomic, weak)IBOutlet UIButton *wrongPricingButton;
@property (nonatomic, weak)IBOutlet UITextView *detailsTextView;
@end
