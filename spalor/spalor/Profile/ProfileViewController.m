//
//  ProfileViewController.m
//  spalor
//
//  Created by Manish on 09/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ProfileViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "NetworkHelper.h"
#import "User.h"
#import "MerchantRatingCell.h"
#import "ChangePasswordViewController.h"

@interface ProfileViewController (){
    User *user;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width/2;
    self.profilePictureView.backgroundColor = [UIColor darkGrayColor];
    self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePictureView.layer.borderWidth = 2.0f;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:MYUSERSTORE];
    user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    self.nameLabel.text = user.name;
    self.emailLabel.text = user.mail;
    
    NSDate *birthdate = [NSDate dateWithTimeIntervalSince1970:[user.dob doubleValue]];
    NSInteger ageinYears = [self ageFromBirthday:birthdate];
    
    self.ageandGenderLabel.text = [NSString stringWithFormat:@"%.0ld, %@",(long)ageinYears,user.gender];
    
    self.reviewsLabel.text = (user.reviews)?user.reviews:@"0";
    self.looksLabel.text = (user.looks)?user.looks:@"0";
    self.merchantsLabel.text = (user.merchants)?user.merchants:@"0";
    self.dealsLabel.text = (user.deals)?user.deals:@"0";
    
    [self downLoadMyImage];

}

- (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}

-(void)downLoadMyImage{
    
    if(self.profilePictureView.image || user.imageData){
        UIImage *image = [UIImage imageWithData:user.imageData];
        self.profilePictureView.image = image;
        return;
    }
    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:[NSString stringWithFormat:@"user/resource/user/%@",user.userId] withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error){
        if(!error && response){
            
            user.imageData = response;
            NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithData:response];
                self.profilePictureView.image = image;
            });
       
        }
        else{
            NSLog(@"error %@",[error localizedDescription]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)logout:(id)sender{
    UINavigationController *navigationController = (UINavigationController *)[self.tabBarController parentViewController];
    [navigationController popToRootViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MYDEALSIMAGESSTORE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MYDEALSSTORE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MYMERCHANTSSTORE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MYLOOKBOOKSTORE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MYUSERSTORE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MYLOCALFILTERSTORE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"filterDict"];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AUTHENTICATED"];

    [[GPPSignIn sharedInstance] signOut];

    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = user.arrayOfReviews.count;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier =  @"ReviewCell";
    Review *review = user.arrayOfReviews[indexPath.row];
    MerchantRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.userName.text = review.name;
    cell.ratingLabel.text = review.text;
    cell.rateView.hidden = NO;
    cell.rateView.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    cell.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    cell.rateView.fullSelectedImage = [UIImage imageNamed:@"star.png"];
    cell.rateView.rating = review.rating.floatValue;
    return cell;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ChangePassword"]){
        ChangePasswordViewController *controller = (ChangePasswordViewController *)[segue destinationViewController];
        controller.user = user;
    }
}




@end
