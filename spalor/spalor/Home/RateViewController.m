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
#import "NetworkHelper.h"
#import "FeSpinnerTenDot.h"


@interface RateViewController ()<UITextViewDelegate>{
    Review *currentReview;
    FeSpinnerTenDot *spinner;
    int overallValue;
    int cleanlinessValue;
    int serviceQualityValue;
    NSString *commentText;
    NSMutableDictionary *reviewDict;
}

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commentTextView.layer.borderColor = [UIColor brownColor].CGColor;
    self.commentTextView.layer.cornerRadius = 4.0f;

    self.commentTextView.delegate = self;
    overallValue = (int) roundf(self.overallSlider.value);
    cleanlinessValue = (int) roundf(self.cleanlinessSlider.value);
    serviceQualityValue = (int) roundf(self.serviceQualitySlider.value);
    reviewDict = [NSMutableDictionary new];
    [reviewDict addEntriesFromDictionary:@{@"merchantId":self.merchantId}];
    [reviewDict addEntriesFromDictionary:@{@"userId":@"8"}];
    [reviewDict addEntriesFromDictionary:@{@"rating":@(overallValue),@"cleanlinessRating":@(cleanlinessValue),@"serviceRating":@(serviceQualityValue)}];
    
    [self.overallSlider setThumbImage:[UIImage imageNamed:@"rate-roller.png"] forState:UIControlStateNormal];
    [self.overallSlider setMinimumTrackImage:[UIImage imageNamed:@"rating-colorbar.png"] forState:UIControlStateNormal];
    
    [self.cleanlinessSlider setThumbImage:[UIImage imageNamed:@"rate-roller.png"] forState:UIControlStateNormal];
    [self.cleanlinessSlider setMinimumTrackImage:[UIImage imageNamed:@"rating-colorbar.png"] forState:UIControlStateNormal];

    [self.serviceQualitySlider setThumbImage:[UIImage imageNamed:@"rate-roller.png"] forState:UIControlStateNormal];
    [self.serviceQualitySlider setMinimumTrackImage:[UIImage imageNamed:@"rating-colorbar.png"] forState:UIControlStateNormal];

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

-(IBAction)submit:(id)sender{
    [self submitReview];
    

}

-(void)submitReview{
    [[NetworkHelper sharedInstance] getArrayFromPostURL:@"user/saveReview" parmeters:@{@"review":reviewDict} completionHandler:^(id response, NSString *url, NSError *error){
        if (error == nil && response!=nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            DLog(@"response string %@",responseDict);
            NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:MYUSERSTORE];
            User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
            [user.arrayOfReviews addObject:currentReview];
            user.reviews = [NSString stringWithFormat:@"%lu",(unsigned long)user.arrayOfReviews.count];
            NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Submitting Review" message:@"Try Again in Sometime" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            });
        }
    }];
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitReview:(id)sender{
    
}

-(IBAction)overallChanged:(UISlider *)sender{
    DLog(@"slider value = %f", sender.value);
    overallValue = (int) roundf(sender.value);
    [reviewDict addEntriesFromDictionary:@{@"rating":@(overallValue),@"cleanlinessRating":@(cleanlinessValue),@"serviceRating":@(serviceQualityValue)}];

}

-(IBAction)cleanlinessChanged:(UISlider *)sender{
    cleanlinessValue = (int) roundf(sender.value);
    [reviewDict addEntriesFromDictionary:@{@"rating":@(overallValue),@"cleanlinessRating":@(cleanlinessValue),@"serviceRating":@(serviceQualityValue)}];

}

-(IBAction)serviceQualityChanged:(UISlider *)sender{
    serviceQualityValue = (int) roundf(sender.value);
    [reviewDict addEntriesFromDictionary:@{@"rating":@(overallValue),@"cleanlinessRating":@(cleanlinessValue),@"serviceRating":@(serviceQualityValue)}];

}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Write a comment..."]) {
        textView.text = @"";
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    commentText = newString;
    [reviewDict addEntriesFromDictionary:@{@"text":commentText}];

    return YES;
}


@end
