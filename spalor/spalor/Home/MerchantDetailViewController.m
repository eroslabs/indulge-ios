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
#import "RateViewController.h"
#import "ReportErrorViewController.h"
#import "DealDetailsViewController.h"
#import "RateCardsViewController.h"
#import "DigitalRateCardsViewController.h"

@interface MerchantDetailViewController (){
    NSMutableArray *myMerchantsArray;
    NSData *myEncodedMerchant;
}
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
    myMerchantsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:MYMERCHANTSSTORE]];
    myEncodedMerchant = [NSKeyedArchiver archivedDataWithRootObject:self.merchant];

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
        NSString *urlString = (self.merchant.image.length)?[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,self.merchant.image]:[NSString stringWithFormat:STATIC_IMAGE_SOURCE];
        NSURL *url = [NSURL URLWithString:urlString];
        [imageView setImageWithURL:url
                  placeholderImage:[UIImage imageNamed:@"placeholder1.png"] options:SDWebImageProgressiveDownload];

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
                      placeholderImage:[UIImage imageNamed:@"placeholder1.png"]options:SDWebImageProgressiveDownload];
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numOfSections = 6;
    return numOfSections;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;
    
    if(section == 0){
        numOfRows = 5;
    }
    else if(section == 1){
        numOfRows = self.merchant.deals.count;//This is deals
    }
    else if(section == 2){
        numOfRows = 1;//This is for map
    }
    else if(section == 3){
        numOfRows = self.merchant.reviews.count;//This is for reviews
    }
    else if(section == 4){
        numOfRows = 1;//This is for extra services
    }
    else if(section == 5){
        numOfRows = 1;//This for found a glitch
        
    }
    
    return numOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            return nil;
            break;
        case 1:
            sectionName = NSLocalizedString(@"Deals", @"Deals");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Directions", @"Directions");
            break;
        case 3:
            sectionName = NSLocalizedString(@"Reviews", @"Reviews");
            break;
        case 4:
            sectionName = NSLocalizedString(@"See all Reviews", @"See all Reviews");
            break;
            // ...
        default:
            sectionName = NSLocalizedString(@"Found a glitch", @"Found a glitch"); ;
            break;
    }
    return sectionName;
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            switch(indexPath.row){
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
            }
        }
        case 1:
            return 94;
            break;
        case 2:
            return 92;
            break;
        case 3:
            return 63;
            break;
        case 4:
            return 63;
            break;
        case 5:
            return 1;
            break;
        default:
            break;
    }
    
    return 0;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.section) {
        case 0:{
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
                    cell.favoriteButton.selected = ([myMerchantsArray containsObject:myEncodedMerchant])?YES:NO;
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
            }
            break;
        }
        
        case 1:{
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
        
        case 2:{
            identifier = @"MapCell";
            MerchantMapCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 3:{
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
        case 4:{
            identifier = @"ExtrasCell";
            MerchantExtrasCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [cell setupWithMerchant:self.merchant];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            break;
        }
        case 5:{
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
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        [(ParallaxHeaderView *)self.mainTableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.mainTableView.contentOffset];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    NSString *sectionName;
    

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.9254f green:0.9254f blue:0.9254f alpha:1.0f];

    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"", @"");
            return nil;
            break;
        case 1:
            sectionName = NSLocalizedString(@"Deals", @"Deals");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Directions", @"Directions");
            break;
        case 3:{
            sectionName = NSLocalizedString(@"Reviews", @"Reviews");
            UIButton *viewAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
            viewAllButton.tag = section;

            [viewAllButton setTitle:@"Write Review" forState:UIControlStateNormal];
            viewAllButton.frame = CGRectMake(tableView.frame.size.width - 100, 5, 100, 20);
            viewAllButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:11.0];
            [viewAllButton setTitleColor:[UIColor colorWithRed:0.2705f green:0.6901f blue:0.6196f alpha:1.0f] forState:UIControlStateNormal];
            [viewAllButton addTarget:self action:@selector(viewAll:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView addSubview:viewAllButton];

            break;
        }
        case 4:{
            sectionName = NSLocalizedString(@"", @"");
            UIButton *viewAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
            viewAllButton.tag = section;

            [viewAllButton setTitle:@"See All Reviews" forState:UIControlStateNormal];
            viewAllButton.frame = CGRectMake(tableView.frame.size.width - 100, 5, 100, 20);
            viewAllButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:11.0];
            [viewAllButton setTitleColor:[UIColor colorWithRed:0.2705f green:0.6901f blue:0.6196f alpha:1.0f] forState:UIControlStateNormal];
            [viewAllButton addTarget:self action:@selector(viewAll:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView addSubview:viewAllButton];

            break;
        }
            // ...
        default:{
            sectionName = NSLocalizedString(@"", @"") ;
            UIButton *viewAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
            viewAllButton.tag = section;

            [viewAllButton setTitle:@"Found a glitch" forState:UIControlStateNormal];
            viewAllButton.frame = CGRectMake(tableView.frame.size.width - 100, 5, 100, 20);
            viewAllButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:11.0];
            [viewAllButton setTitleColor:[UIColor colorWithRed:0.2705f green:0.6901f blue:0.6196f alpha:1.0f] forState:UIControlStateNormal];
            [viewAllButton addTarget:self action:@selector(viewAll:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView addSubview:viewAllButton];

            break;
        }
    }

    
    if (sectionName.length>0) {
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(20, 5, 150, 20);
        myLabel.font = [UIFont fontWithName:@"Avenir Next Demi Bold" size:12.0f];
        
        myLabel.text = sectionName;
        [headerView addSubview:myLabel];
    }
   

    
    return headerView;
    
}


#pragma mark -
#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AllReviews"]) {
        AllReviewsViewController *controller = (AllReviewsViewController *)segue.destinationViewController;
        controller.arrayOfReviews = self.merchant.reviews;
    }
    if ([segue.identifier isEqualToString:@"Rate"]) {
        RateViewController *controller = (RateViewController *)segue.destinationViewController;
        controller.merchantId = self.merchant.merchantid;
    }
    if ([segue.identifier isEqualToString:@"ReportError"]) {
        ReportErrorViewController  *controller = (ReportErrorViewController *)segue.destinationViewController;
        controller.merchantId = self.merchant.merchantid;
    }
    if([segue.identifier isEqualToString:@"ShowDealDetail"]){
        DealDetailsViewController *controller = (DealDetailsViewController *)segue.destinationViewController;
        controller.deal = self.merchant.deals[0];
    }
    if ([segue.identifier isEqualToString:@"ShowRateCards"]) {
        RateCardsViewController *controller = (RateCardsViewController *)segue.destinationViewController;
        controller.imageUrls = self.merchant.menus;
    }
    if ([segue.identifier isEqualToString:@"ShowDigitalRateCards"]) {
        DigitalRateCardsViewController *controller = (DigitalRateCardsViewController *)segue.destinationViewController;
        controller.merchant = self.merchant;
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


-(IBAction)viewAll:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    switch (senderButton.tag)
    {
        case 3:{
            //Show all looks
            [self performSegueWithIdentifier:@"Rate" sender:nil];
            
            break;
        }
        case 4:{
            //Show all looks
            [self performSegueWithIdentifier:@"AllReviews" sender:nil];
            
            break;
        }
        case 5:{
            //Show all deals
            [self performSegueWithIdentifier:@"ReportError" sender:nil];
            
            break;
        }
        default:{
            break;
        }
    }
    
}


-(IBAction)showAllRateCards:(id)sender{
    if (self.merchant.services.count == 0) {
        return;
    }
    if(self.merchant.menus.count == 0){
        [self performSegueWithIdentifier:@"ShowDigitalRateCards" sender:nil];

    }
    else{
        [self performSegueWithIdentifier:@"ShowRateCards" sender:nil];

    }


}

-(IBAction)redeem:(id)sender{
    [self performSegueWithIdentifier:@"ShowDealDetail" sender:nil];
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)share:(id)sender{
    NSString *texttoshare = self.merchant.name; //this is your text string to share
    UIImage *imagetoshare = [UIImage imageNamed:@"merchant-massage.png"]; //this is your image to share
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

-(IBAction)call:(id)sender{
    NSString *cleanedString = [[self.merchant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];
}

-(IBAction)favorite:(id)sender{
    
    UIButton *senderButton = (UIButton *)sender;
    if (senderButton.selected) {
        [myMerchantsArray removeObject:myEncodedMerchant];
    }
    else {
        [myMerchantsArray addObject:myEncodedMerchant];
        
    }
    
    senderButton.selected = !senderButton.selected;

    [[NSUserDefaults standardUserDefaults] setObject:myMerchantsArray forKey:MYMERCHANTSSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mainTableView reloadData];
    
}



@end

