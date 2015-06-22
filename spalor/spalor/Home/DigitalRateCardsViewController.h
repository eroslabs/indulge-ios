//
//  DigitalRateCardsViewController.h
//  spalor
//
//  Created by Manish on 22/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Merchant;

@interface DigitalRateCardsViewController : UIViewController
@property (nonatomic, strong) Merchant *merchant;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end
