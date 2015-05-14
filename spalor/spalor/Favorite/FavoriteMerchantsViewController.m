//
//  FavoriteMerchantsViewController.m
//  spalor
//
//  Created by Manish on 30/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FavoriteMerchantsViewController.h"
#import "MyLookbookCell.h"
#import "MyDealsCell.h"
#import "MyServiceProviderCell.h"
#import "Merchant.h"
#import "Deal.h"
#import "AllDealsViewController.h"

@interface FavoriteMerchantsViewController (){
    NSArray *myLookBookImagesArray;
    NSArray *myMerchantsArray;
    NSArray *myDealsArray;
}

@end

@implementation FavoriteMerchantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    myLookBookImagesArray = [[NSUserDefaults standardUserDefaults] arrayForKey:MYLOOKBOOKSTORE];
    myDealsArray = [[NSUserDefaults standardUserDefaults] arrayForKey:MYDEALSSTORE];
    myMerchantsArray = [[NSUserDefaults standardUserDefaults] arrayForKey:MYMERCHANTSSTORE];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"AllDeals"]){
        AllDealsViewController *controller = (AllDealsViewController *)[segue destinationViewController];
        controller.dataArray = myDealsArray;
    }
}


#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numOfSections = 3;
    return numOfSections;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;

    if(section == 0){
        numOfRows = (myLookBookImagesArray.count)?1:0;//This is the favorite looks
    }
    else if(section == 1){
        numOfRows = (myDealsArray.count)?1:0;//This is deals
    }
    else{
        numOfRows = myMerchantsArray.count;//This is your favorite Merchants
    }
    
    return numOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"My Lookbook", @"My Lookbook");
            break;
        case 1:
            sectionName = NSLocalizedString(@"My Deals", @"My Deals");
            break;
            // ...
        default:
            sectionName = NSLocalizedString(@"My Service Provider", @"My Service Provider"); ;
            break;
    }
    return sectionName;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heightOfRow = 0;
    
    if(indexPath.section == 0){
        heightOfRow = 60;
    }
    else if(indexPath.section == 1){
        heightOfRow = 152;
    }
    else{
        heightOfRow = 100;//This is your favorite Merchants
    }
    
    return heightOfRow;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseId = @"";
    
    if(indexPath.section == 0){
        reuseId = @"MyLooksCell";
        MyLookbookCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        [cell setupCellWithMyLooksImagesArray:myLookBookImagesArray];
        return cell;

    }
    else if(indexPath.section == 1){
        reuseId = @"MyDealsCell";
        MyDealsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        [cell setupCellWithMyDealArray:myDealsArray];
        return cell;

    }
    else{
        reuseId = @"MyServiceProviderCell";//This is your favorite Merchants
        MyServiceProviderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        Merchant *myMerchant = [NSKeyedUnarchiver unarchiveObjectWithData:myMerchantsArray[indexPath.row]];
        NSLog(@"myMerchant %@",myMerchant.name);
        [cell setupCellWithMerchant:myMerchant];
        return cell;

    }

    //cell.textLabel.text = @"Sample";
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    NSString *sectionName;
    
    UIButton *viewAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewAllButton setTitle:@"View All" forState:UIControlStateNormal];
    
    switch (section)
    {
        case 0:{
            sectionName = NSLocalizedString(@"My Lookbook", @"My Lookbook");
            viewAllButton.tag = 0;
            break;
        }
        case 1:{
            sectionName = NSLocalizedString(@"My Deals", @"My Deals");
            viewAllButton.tag = 1;
            break;
        }
            // ...
        default:{
            sectionName = NSLocalizedString(@"My Service Provider", @"My Service Provider");
            viewAllButton.tag = 2;
            break;
        }
    }

    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 5, 150, 20);
    myLabel.font = [UIFont fontWithName:@"Avenir Next Demi Bold" size:12.0f];
    
    myLabel.text = sectionName;
    
    viewAllButton.frame = CGRectMake(tableView.frame.size.width - 100, 5, 100, 20);
    viewAllButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11.0];
    [viewAllButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [viewAllButton addTarget:self action:@selector(viewAll:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.9254f green:0.9254f blue:0.9254f alpha:1.0f];
    [headerView addSubview:myLabel];
    [headerView addSubview:viewAllButton];
    
    return headerView;
    
}

-(IBAction)viewAll:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    switch (senderButton.tag)
    {
        case 0:{
            //Show all looks
            break;
        }
        case 1:{
            //Show all deals
            [self performSegueWithIdentifier:@"AllDeals" sender:nil];
            break;
        }
            // ...
        default:{
            //Show all service providers
            break;
        }
    }

}

@end
