//
//  MyLookbookCell.h
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLookbookCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
-(void)setupCellWithMyLooksImagesArray:(NSArray *)imagesArray;
@end
