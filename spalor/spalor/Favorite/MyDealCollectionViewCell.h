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
@property (nonatomic, weak) IBOutlet UIImageView *merchantProfileImageView;

@property (nonatomic, weak) IBOutlet UILabel *merchantName;
@property (nonatomic, weak) IBOutlet UILabel *merchantAddress;
@property (nonatomic, weak) IBOutlet UILabel *validTillLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantRatingLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantServicesLabel;

@property (nonatomic, weak) IBOutlet UIImageView *categoryId1;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId2;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId3;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId4;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId5;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId6;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId7;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId8;
@property (nonatomic, weak) IBOutlet UIImageView *categoryId9;


@end
