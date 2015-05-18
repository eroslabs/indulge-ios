//
//  RateViewController.m
//  spalor
//
//  Created by Manish on 27/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "RateViewController.h"
#import "User.h"
#import "Review.h"

@interface RateViewController (){
    Review *currentReview;
}

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - User Actions

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitReview:(id)sender{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:MYUSERSTORE];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    [user.arrayOfReviews addObject:currentReview];
    user.reviews = [NSString stringWithFormat:@"%lu",(unsigned long)user.arrayOfReviews.count];
    NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];

}

-(IBAction)overallChanged:(id)sender{
    
}

-(IBAction)cleanlinessChanged:(id)sender{
    
}

-(IBAction)serviceQualityChanged:(id)sender{
    
}

@end
