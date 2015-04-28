//
//  AllReviewsViewController.m
//  spalor
//
//  Created by Manish on 27/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "AllReviewsViewController.h"
#import "MerchantRatingCell.h"
#import "Review.h"

@interface AllReviewsViewController ()

@end

@implementation AllReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Datasource and Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = self.arrayOfReviews.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ratingCell"];
    Review *review = self.arrayOfReviews[indexPath.row];
    cell = [cell setupWithMerchantReview:review];
    return cell;
}


#pragma mark - User Actions 

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
