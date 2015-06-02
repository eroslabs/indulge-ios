//
//  FilterDetailViewController.h
//  spalor
//
//  Created by Manish on 21/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterDetailViewController : UIViewController
@property NSArray *arrayOfCategories;
@property (nonatomic, weak) IBOutlet UIScrollView *selectedServicesScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *allCategoriesScrollView;
@property (nonatomic, weak) IBOutlet UIView *allCategoriesView;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UITableView *autoSuggestTableView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIView *overlayView;

- (IBAction)filterSearchTextField:(id)sender;
- (IBAction)hideFilter:(id)sender;
@end
