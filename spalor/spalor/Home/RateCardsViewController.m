//
//  RateCardsViewController.m
//  spalor
//
//  Created by Manish on 01/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "RateCardsViewController.h"
#include "RateCardCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface RateCardsViewController ()

@end

@implementation RateCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Collection View Data Source Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.imageUrls.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RateCard";
    
    RateCardCollectionViewCell *cell = (RateCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    NSString *url = [NSURL URLWithString:self.imageUrls[indexPath.row]];
    [cell.rateCardImageView setImageWithURL:url
                           placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload ];

    return cell;
}


@end
