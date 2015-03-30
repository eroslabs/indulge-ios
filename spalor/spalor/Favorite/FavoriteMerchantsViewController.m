//
//  FavoriteMerchantsViewController.m
//  spalor
//
//  Created by Manish on 30/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "FavoriteMerchantsViewController.h"

@interface FavoriteMerchantsViewController ()

@end

@implementation FavoriteMerchantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numOfSections = 3;
    return numOfSections;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 0;

    if(section == 1){
        numOfRows = 1;
    }
    else if(section == 2){
        numOfRows = 1;
    }
    else{
        numOfRows = 10;//This is your favorite Merchants
    }
    
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heightOfRow = 0;
    
    if(indexPath.section == 1){
        heightOfRow = 150;
    }
    else if(indexPath.section == 2){
        heightOfRow = 150;
    }
    else{
        heightOfRow = 100;//This is your favorite Merchants
    }
    
    return heightOfRow;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseId = @"";
    UITableViewCell *cell;
    
    if(indexPath.section == 1){
        reuseId = @"MyLooksCell";
        cell = [tableView dequeueReusableCellWithIdentifier:reuseId];

    }
    else if(indexPath.section == 2){
        reuseId = @"MyDealsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:reuseId];

    }
    else{
        reuseId = @"MyServiceProviderCell";//This is your favorite Merchants
        cell = [tableView dequeueReusableCellWithIdentifier:reuseId];

    }

    //cell.textLabel.text = @"Sample";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}

@end
