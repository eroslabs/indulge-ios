//
//  HomeViewController.h
//  spalor
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *recommededButton1;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton2;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton3;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton4;
@property (weak, nonatomic) IBOutlet UIButton *recommededButton5;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundOverlayView;
@property (weak, nonatomic) UILabel *headerTitleLabel;
@property (weak, nonatomic) UIImageView *searchBarBackgroundImageView;
@property (weak, nonatomic) UIImageView *locationSearchBackgroundImageView;
@property (weak, nonatomic) UITextField *searchTextField;
@property (weak, nonatomic) UITextField *locationSearchTextField;

@end
