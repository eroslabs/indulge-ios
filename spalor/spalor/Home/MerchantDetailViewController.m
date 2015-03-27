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

@interface MerchantDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic) NSDictionary *story;
@end

@implementation MerchantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load Dummy PlaceHolder Comments
    [self loadPlaceHolderComments];
    
    // Set TableViewWidth to the storyCommentCell so that comment cell is layouts itself for all ios Devices
    [StoryCommentCell setTableViewWidth:self.mainTableView.frame.size.width];
    
    // Create ParallaxHeaderView with specified size, and set it as uitableView Header, that's it
    //    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"HeaderImage"] forSize:CGSizeMake(self.mainTableView.frame.size.width, 300)];
    
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = [self.story[kCommentsKey] count];
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0;
    NSDictionary *commentDetails = self.story[kCommentsKey][indexPath.row];
    NSString *comment = commentDetails[kCommentKey];
    
    cellHeight += [StoryCommentCell cellHeightForComment:comment];
    return cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self customCellForIndex:indexPath];
    NSDictionary *comment = self.story[kCommentsKey][indexPath.row];
    [(StoryCommentCell *)cell  configureCommentCellForComment:comment];
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

#pragma mark -
#pragma mark Private

- (void)loadPlaceHolderComments
{
    NSMutableDictionary *story = [NSMutableDictionary dictionary];
    story[@"story"] = @"I Love My Friends";
    story[@"likes"] = @1;
    
    
    NSArray *comments = @[
                          @{kCommentKey: @"Friendship is always a sweet responsibility, never an opportunity", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"True friendship is when you walk into their house and your WiFi connects automatically", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"True friendship multiplies the good in life and divides its evils. Strive to have friends, for life without friends is like life on a desert island… to find one real friend in a lifetime is good fortune; to keep him is a blessing.", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"Like Thought Catalog on Facebook", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"The language of friendship is not words but meanings", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"Don’t walk behind me; I may not lead. Don’t walk in front of me; I may not follow. Just walk beside me and be my friend.", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"Friendship is like money, easier made than kept. – Samuel Butler", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"A friend is one that knows you as you are, understands where you have been, accepts what you have become, and still, gently allows you to grow. – William Shakespeare", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"I think if I’ve learned anything about friendship, it’s to hang in, stay connected, fight for them, and let them fight for you. Don’t walk away, don’t be distracted, don’t be too busy or tired, don’t take them for granted. Friends are part of the glue that holds life and faith together. Powerful stuff", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"I value the friend who for me finds time on his calendar, but I cherish the friend who for me does not consult his calendar", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"},
                          @{kCommentKey: @"Every friendship travels at sometime through the black valley of despair. This tests every aspect of your affection. You lose the attraction and the magic. Your sense of each other darkens and your presence is sore. If you can come through this time, it can purify with your love, and falsity and need will fall away. It will bring you onto new ground where affection can grow again Friendship improves happiness, and abates misery, by doubling our joys, and dividing our grief Do not save your loving speeches For your friends till they are dead Do not write them on their tombstones, Speak them rather now instead", kTimeKey : @"1 Min Ago", kLikesCountKey : @"3"}
                          ];
    
    [story setObject:comments forKey:kCommentsKey];
    self.story = story;
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

