//
//  MyDealsCell.h
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDealsCell : UITableViewCell
@property NSArray *dataArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
-(void)setupCellWithMyDealImagesArray:(NSArray *)imagesArray;
-(void)setupCellWithMyDealArray:(NSArray *)dataArray;
@end
