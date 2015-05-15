//
//  MyLooksTableViewCell.h
//  spalor
//
//  Created by Manish on 15/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyLook;

@interface MyLooksTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantServiceLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *merchantRatingLabel;

-(void)setupWithLookObject:(MyLook *)look;
@end
