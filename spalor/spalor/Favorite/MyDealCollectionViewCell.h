//
//  MyDealCollectionViewCell.h
//  spalor
//
//  Created by Manish on 30/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDealCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *couponCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantServicesLabel;
@property (nonatomic, weak) IBOutlet UILabel *validTillLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountLabel;
@property (nonatomic, weak) IBOutlet UIButton *callButton;

@end
