//
//  AllDealsViewController.h
//  spalor
//
//  Created by Manish on 13/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllDealsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property NSArray *dataArray;
@property (nonatomic, weak) IBOutlet UIButton *activeDealsButton;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *pastDealsButton;
@end
