//
//  AllLooksViewController.m
//  spalor
//
//  Created by Manish on 14/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "AllLooksViewController.h"
#import "MyLooksCollectionViewCell.h"

@interface AllLooksViewController ()

@end

@implementation AllLooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection View DataSource and Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyLooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LooksCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithData:self.dataArray[indexPath.row]];
    return cell;
}



#pragma mark - User Actions

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
