//
//  ReportErrorViewController.m
//  spalor
//
//  Created by Manish on 27/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "ReportErrorViewController.h"
#import "NetworkHelper.h"

@interface ReportErrorViewController (){
    NSMutableDictionary *errorDict;
}

@end

@implementation ReportErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    user//reportError
    
//    Object name "error"
//    private Boolean wrongPhone;
//    private Boolean wrongAddress;
//    private Boolean closedClosed;
//    private Boolean wrongPricing;
//    private String details;
//    private Integer userId;
//    private Integer merchantId;
    
    errorDict = [NSMutableDictionary new];
    [errorDict addEntriesFromDictionary:@{@"merchantId":self.merchantId,@"userId":@"8"}];
    
    [errorDict addEntriesFromDictionary:@{@"wrongPhone":@(self.wrongPhoneButton.selected),@"wrongAddress":@(self.wrongAddressButton.selected),@"closedClosed":@(self.closedClosedButton.selected),@"wrongPricing":@(self.wrongPricingButton.selected),@"details":self.detailsTextView.text}];

    self.detailsTextView.layer.borderColor = [UIColor brownColor].CGColor;
    self.detailsTextView.layer.cornerRadius = 4.0f;
    
    
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

-(IBAction)buttonSelected:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    senderButton.selected = !senderButton.selected;
    [errorDict addEntriesFromDictionary:@{@"wrongPhone":@(self.wrongPhoneButton.selected),@"wrongAddress":@(self.wrongAddressButton.selected),@"closedClosed":@(self.closedClosedButton.selected),@"wrongPricing":@(self.wrongPricingButton.selected),@"details":self.detailsTextView.text}];

}

-(IBAction)submit:(id)sender{
    [[NetworkHelper sharedInstance] getArrayFromPostURL:@"user/reportError" parmeters:@{@"error":errorDict} completionHandler:^(id response, NSString *url, NSError *error){
        if (error == nil && response!=nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            DLog(@"response string %@",responseDict);
            
        }
    }];
    
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Other/More Details"]) {
        textView.text = @"";
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [errorDict addEntriesFromDictionary:@{@"text":newString}];
    
    return YES;
}


@end
