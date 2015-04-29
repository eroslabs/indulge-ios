//
//  MyLookbookCell.m
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MyLookbookCell.h"

@implementation MyLookbookCell
-(void)setupCellWithMyLooksImagesArray:(NSArray *)imagesArray{
    
    int index = 0;
    
    for (NSData *imageData in imagesArray) {
        UIImage *myImage = [UIImage imageWithData:imageData];
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
        myImageView.frame = CGRectMake(index*60 + 10, 0, 50, self.scrollView.frame.size.height);
        [self.scrollView addSubview:myImageView];
    }
}
@end
