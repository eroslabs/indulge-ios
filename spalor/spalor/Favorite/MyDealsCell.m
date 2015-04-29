//
//  MyDealsCell.m
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MyDealsCell.h"

@implementation MyDealsCell
-(void)setupCellWithMyDealImagesArray:(NSArray *)imagesArray{
    int index = 0;
    
    for (NSData *imageData in imagesArray) {
        UIImage *myImage = [UIImage imageWithData:imageData];
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
        myImageView.frame = CGRectMake(index*210 + 10, 0, 210, self.scrollView.frame.size.height);
        [self.scrollView addSubview:myImageView];
    }

}
@end
