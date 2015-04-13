//
//  NearbyViewController.h
//  spalor
//
//  Created by Manish on 13/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundOverlayView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *locationIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *searchBarBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationSearchBackgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationSearchTextField;
@end
