//
//  MerchantRatingCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantRatingCell.h"

@implementation MerchantRatingCell
-(MerchantRatingCell *)setupWithMerchantReview:(Review *)review{
    self.rateView.hidden = NO;
    self.rateView.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"star.png"];
    self.rateView.rating = review.rating.floatValue;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;
    self.userName.text = review.name;
    self.ratingLabel.text = review.text;
    self.userImageView.hidden = NO;
    self.userImageView.image = [UIImage imageNamed:@""];
    return self;
}

-(MerchantRatingCell *)setupWithMerchantwithNoReviews{
    self.rateView.hidden = YES;
    self.userName.text = @"";
    self.ratingLabel.text = @"No Reviews yet";
    self.userImageView.hidden = YES;
    return self;
}
@end
