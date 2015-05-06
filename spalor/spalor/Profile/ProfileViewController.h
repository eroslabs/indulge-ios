//
//  ProfileViewController.h
//  spalor
//
//  Created by Manish on 09/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageandGenderLabel;
@property (strong, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (strong, nonatomic) IBOutlet UILabel *looksLabel;
@property (strong, nonatomic) IBOutlet UILabel *dealsLabel;
@property (strong, nonatomic) IBOutlet UILabel *merchantsLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)logout:(id)sender;
-(IBAction)changePassword:(id)sender;
@end