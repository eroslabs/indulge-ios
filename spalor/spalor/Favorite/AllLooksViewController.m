//
//  AllLooksViewController.m
//  spalor
//
//  Created by Manish on 14/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "AllLooksViewController.h"
#import "MyLooksTableViewCell.h"

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


#pragma mark - Table Datasource and Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = self.dataArray.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myLooksCell"];
    MyLook *lookObj = (MyLook *)self.dataArray[indexPath.row];
    [cell setupWithLookObject:lookObj];
    return cell;
}


#pragma mark - User Actions

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
