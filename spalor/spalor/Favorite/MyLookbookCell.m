//
//  MyLookbookCell.m
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MyLookbookCell.h"
#import "MyLook.h"


@implementation MyLookbookCell
-(void)setupCellWithMyLooksImagesArray:(NSArray *)imagesArray{
    
    int index = 0;
    for (MyLook *look in imagesArray) {
        UIImage *myImage = [UIImage imageWithData:look.imageData];
        UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
        myImageView.frame = CGRectMake(index*60 + 10, 5, 50, 50);
        index++;
        [self.scrollView addSubview:myImageView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(index*60 + 20, self.scrollView.contentSize.height)];

}
@end
