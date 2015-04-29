//
//  MyDealsCell.h
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDealsCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
-(void)setupCellWithMyDealImagesArray:(NSArray *)imagesArray;
@end
