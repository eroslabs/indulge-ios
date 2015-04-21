//
//  MerchantListViewController.h
//  spalor
//
//  Created by Manish on 13/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantListViewController : UIViewController
@property (nonatomic , strong) NSString *searchText;
@property (nonatomic , weak) IBOutlet UITableView *tableview;
@property (nonatomic , weak) IBOutlet UIView *loaderContainerView;
@property (nonatomic , weak) IBOutlet UILabel *totalCountLabel;

-(IBAction)goBackToSearch:(id)sender;
@end
