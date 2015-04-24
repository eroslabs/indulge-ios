//
//  MerchantDetailViewController.m
//  spalor
//
//  Created by Manish on 17/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantDetailViewController.h"
#import "ParallaxHeaderView.h"
#import "StoryCommentCell.h"
#import "RateView.h"

@interface MerchantDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic) NSDictionary *story;
@end

@implementation MerchantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.mainTableView.frame.size.width, 200)];
    
    headerScrollView.pagingEnabled = YES;
    
    for(int i=0;i<4;i++){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*headerScrollView.frame.size.width, 0, headerScrollView.frame.size.width, 200)];
        imageView.image = [UIImage imageNamed:@"HeaderImage"];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [headerScrollView addSubview:imageView];
    }
    
    headerScrollView.showsVerticalScrollIndicator = NO;
    
    
    headerScrollView.contentSize = CGSizeMake(4*headerScrollView.frame.size.width,headerScrollView.frame.size.height);
    
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:headerScrollView];
    
    
    headerView.headerTitleLabel.text = self.story[@"story"];
    
    [self.mainTableView setTableHeaderView:headerView];
    
    
    /*
     
     self.rateView.notSelectedImage = [UIImage imageNamed:@"kermit_empty.png"];
     self.rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
     self.rateView.fullSelectedImage = [UIImage imageNamed:@"kermit_full.png"];
     self.rateView.rating = 3.5;
     self.rateView.editable = NO;
     self.rateView.maxRating = 5;
     self.rateView.delegate = self;
     
     */

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    //[(ParallaxHeaderView *)self.mainTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.mainTableView.contentOffset];

    [super viewDidAppear:animated];
    [(ParallaxHeaderView *)self.mainTableView.tableHeaderView refreshBlurViewForNewImage];


}


-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table Datasource and Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 10;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 160;
            break;
        case 1:
            return 63;
            break;
        case 2:
            return 100;
            break;
        case 3:
            return 100;
            break;
        case 4:
            return 60;
            break;
        case 5:
            return 100;
            break;
        case 6:
            return 100;
            break;
        case 7:
            return 63;
            break;
        case 8:
            return 63;
            break;
        case 9:
            return 63;
            break;
        default:
            break;
    }
    
    return 0;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"InfoCell";
            break;
        case 1:
            identifier = @"SocialCell";
            break;
        case 2:
            identifier = @"ScheduleCell";
            break;
        case 3:
            identifier = @"PriceRangeCell";
            break;
        case 4:
            identifier = @"RecommendedCell";
            break;
        case 5:
            identifier = @"DealCell";
            break;
        case 6:
            identifier = @"MapCell";
            break;
        case 7:
            identifier = @"RatingCell";
            break;
        case 8:
            identifier = @"ExtrasCell";
            break;
        case 9:
            identifier = @"ErrorCell";
            break;
        default:
            break;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        [(ParallaxHeaderView *)self.mainTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.mainTableView.contentOffset];
    }
}

#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainTableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.mainTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}


- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = kCellIdentifier;
    cell = [self.mainTableView dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [StoryCommentCell storyCommentCellForTableWidth:self.mainTableView.frame.size.width];
    }
    return cell;
}

@end

