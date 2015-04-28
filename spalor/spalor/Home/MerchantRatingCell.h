//
//  MerchantRatingCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"
#import "RateView.h"

@interface MerchantRatingCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property (nonatomic, weak) IBOutlet RateView *rateView;

-(MerchantRatingCell *)setupWithMerchantReview:(Review *)merchant;
-(MerchantRatingCell *)setupWithMerchantwithNoReviews;
@end
