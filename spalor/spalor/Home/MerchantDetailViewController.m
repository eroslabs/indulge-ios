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
#import "MerchantInfoCell.h"
#import "MerchantSocialCell.h"
#import "MerchantScheduleCell.h"
#import "MerchantPriceRangeCell.h"
#import "MerchantRecommendedCell.h"
#import "MerchantDealCell.h"
#import "MerchantMapCell.h"
#import "MerchantRatingCell.h"
#import "MerchantExtrasCell.h"
#import "MerchantErrorCell.h"
#import "AllReviewsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MerchantDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic) NSDictionary *story;
@end

@implementation MerchantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*
     
     self.rateView.notSelectedImage = [UIImage imageNamed:@"kermit_empty.png"];
     self.rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
     self.rateView.fullSelectedImage = [UIImage imageNamed:@"kermit_full.png"];
     self.rateView.rating = 3.5;
     self.rateView.editable = NO;
     self.rateView.maxRating = 5;
     self.rateView.delegate = self;
     
     */
    
    [self setTableHeaderView];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    //[(ParallaxHeaderView *)self.mainTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.mainTableView.contentOffset];

    [super viewDidAppear:animated];
    [(ParallaxHeaderView *)self.mainTableView.tableHeaderView refreshBlurViewForNewImage];


}



#pragma mark - Table Datasource and Delegate

-(void)setTableHeaderView{
    UIScrollView *headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.mainTableView.frame.size.width, 200)];
    
    headerScrollView.pagingEnabled = YES;
    
    if(self.merchant.merchantImageUrls.count == 0){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerScrollView.frame.size.width, 200)];
        NSString *urlString = (self.merchant.image.length)?[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,self.merchant.image]:[NSString stringWithFormat:@"%@6/ab.jpg",INDULGE_MERCHANT_IMAGE_BASE_URL];
        NSURL *url = [NSURL URLWithString:urlString];
        [imageView setImageWithURL:url
                  placeholderImage:[UIImage imageNamed:@"image.png"] options:SDWebImageProgressiveDownload];

        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [headerScrollView addSubview:imageView];
    }
    else{
        for(int i=0;i<self.merchant.merchantImageUrls.count;i++){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*headerScrollView.frame.size.width, 0, headerScrollView.frame.size.width, 200)];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,self.merchant.merchantImageUrls[i]]];
            
            [imageView setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"image.png"]options:SDWebImageProgressiveDownload];
            
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            [headerScrollView addSubview:imageView];
        }
    }
    

    
    
    //Add top header info image view
//    UIImage *infoImage = [UIImage imageNamed:@"12.png"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-infoImage.size.width/2,headerScrollView.frame.size.height-20, infoImage.size.width, infoImage.size.height)];
//    imageView.image = infoImage;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.clipsToBounds = NO;
//    [headerScrollView addSubview:imageView];
//    headerScrollView.clipsToBounds = NO;
//    headerScrollView.showsVerticalScrollIndicator = NO;
//    
//
    
    int count = (self.merchant.merchantImageUrls.count!=nil)?self.merchant.merchantImageUrls.count:1;
    headerScrollView.contentSize = CGSizeMake(count*headerScrollView.frame.size.width,headerScrollView.frame.size.height);
    
    
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithSubView:headerScrollView];
    
    
    headerView.headerTitleLabel.text = self.story[@"story"];
    
    [self.mainTableView setTableHeaderView:headerView];
    

}

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
            return 79;
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
            return 93;
            break;
        case 6:
            return 100;
            break;
        case 7:
            return 92;
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
        case 0:{
            identifier = @"InfoCell";
            MerchantInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case 1:{
            identifier = @"SocialCell";
            MerchantSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 2:{
            identifier = @"ScheduleCell";
            MerchantScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 3:{
            identifier = @"PriceRangeCell";
            MerchantPriceRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 4:{
            identifier = @"RecommendedCell";
            MerchantRecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;

            break;
        }
        case 5:{
            identifier = @"DealCell";
            MerchantDealCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(self.merchant.deals.count>0){
                cell = [cell setupWithMerchant:self.merchant.deals[0]];
            }
            else{
                cell = [cell setupWitDefault];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 6:{
            identifier = @"MapCell";
            MerchantMapCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 7:{
            identifier = @"RatingCell";
            MerchantRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (self.merchant.reviews.count == 0)
                cell = [cell setupWithMerchantwithNoReviews];
            else
                cell = [cell setupWithMerchantReview:self.merchant.reviews[0]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 8:{
            identifier = @"ExtrasCell";
            MerchantExtrasCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 9:{
            identifier = @"ErrorCell";
            MerchantErrorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        // Open Reviews Segue
        
        //Commented if for testing
        //if (self.merchant.reviews.count > 0)
            [self performSegueWithIdentifier:@"AllReviews" sender:nil];
    }
    else if (indexPath.row == 9){
        //Open Error segue
        [self performSegueWithIdentifier:@"ReportError" sender:nil];

    }
    else if (indexPath.row == 0){
        //Open Rating Segue
        [self performSegueWithIdentifier:@"Rate" sender:nil];
        
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        [(ParallaxHeaderView *)self.mainTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.mainTableView.contentOffset];
    }
}

#pragma mark -
#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AllReviews"]) {
        AllReviewsViewController *controller = (AllReviewsViewController *)segue.destinationViewController;
        controller.arrayOfReviews = self.merchant.reviews;
    }
}


#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainTableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.mainTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}


#pragma mark - User Actions 

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)share:(id)sender{
    
}

-(IBAction)call:(id)sender{
    NSString *cleanedString = [[self.merchant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];
}

-(IBAction)favorite:(id)sender{
    NSMutableArray *myMerchantsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:MYMERCHANTSSTORE]];
    NSData *myEncodedMerchant = [NSKeyedArchiver archivedDataWithRootObject:self.merchant];
    [myMerchantsArray addObject:myEncodedMerchant];
    [[NSUserDefaults standardUserDefaults] setObject:myMerchantsArray forKey:MYMERCHANTSSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

