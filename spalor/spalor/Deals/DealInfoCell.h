//
//  DealInfoCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealInfoCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageRating;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountOffLabel;

@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) IBOutlet UIImageView *locationimageview;

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView1;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView2;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView3;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView4;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView5;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView6;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView7;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView8;
@property (nonatomic, weak) IBOutlet UIImageView *serviceCategoryImageView9;

-(DealInfoCell *)setupCellWithDeal:(Deal *)deal;
@end
