//
//  HomeViewController.h
//  spalor
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *recommededButton1;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton2;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton3;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton4;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton5;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *goBackFromSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundOverlayView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *filterView;

@property (weak, nonatomic) IBOutlet UILabel *merchantListResults;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *searchBarBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationSearchBackgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationSearchTextField;

-(IBAction)goBackFromSearch:(id)sender;

@end
