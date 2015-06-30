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
    cell.callButton.tag = indexPath.row;
    cell.shareButton.tag = indexPath.row;
    [cell setupWithLookObject:lookObj];
    return cell;
}


#pragma mark - User Actions

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)callMerchant:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
     MyLook *lookObj = (MyLook *)self.dataArray[senderButton.tag];
    NSString *cleanedString = [[lookObj.merchantPhone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];

}

-(IBAction)shareMerchant:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    MyLook *lookObj = (MyLook *)self.dataArray[senderButton.tag];
    NSString *texttoshare = lookObj.merchantName; //this is your text string to share
    UIImage *imagetoshare = [UIImage imageNamed:@"merchant-massage.png"]; //this is your image to share
    NSArray *activityItems = @[texttoshare, imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

@end
