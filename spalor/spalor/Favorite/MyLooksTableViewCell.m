//
//  MyLooksTableViewCell.m
//  spalor
//
//  Created by Manish on 15/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MyLooksTableViewCell.h"

@implementation MyLooksTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithLookObject:(MyLook *)look{
    self.merchantNameLabel.text = look.merchantName;
    self.merchantAddressLabel.text = look.merchantAddress;
    self.merchantRatingLabel.text = look.merchantRating;
    self.merchantServiceLabel.text = look.merchantService;
    self.image.image = [UIImage imageWithData:look.imageData];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *result = [df stringFromDate:look.date];
    

    self.dateLabel.text = result;
}
@end
