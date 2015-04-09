//
//  HomeViewController.m
//  spalor
//
//  Created by Manish on 12/03/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "HomeViewController.h"
#import "NetworkHelper.h"

@interface HomeViewController (){
    BOOL merchantListing;
}
@end

@implementation HomeViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //[[NetworkHelper sharedInstance] formRequestwithemail:@"vikas@eroslabs.co"];
    merchantListing = YES;
    [self setupRecomendedButttons];
}

-(void)setupRecomendedButttons{
    self.recommededButton1.layer.cornerRadius = 4.0f;
    self.recommededButton2.layer.cornerRadius = 4.0f;
    self.recommededButton3.layer.cornerRadius = 4.0f;
    self.recommededButton4.layer.cornerRadius = 4.0f;
    self.recommededButton5.layer.cornerRadius = 4.0f;

    self.recommededButton1.clipsToBounds = YES;
    self.recommededButton2.clipsToBounds = YES;
    self.recommededButton3.clipsToBounds = YES;
    self.recommededButton4.clipsToBounds = YES;
    self.recommededButton5.clipsToBounds = YES;
    
    [self.recommededButton1 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.recommededButton2 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.recommededButton3 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.recommededButton4 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.recommededButton5 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];

}

#pragma mark -
#pragma mark UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 10;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!merchantListing) {
        return 62;
    }
    else{
        return 152;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    
    if(!merchantListing){
        identifier = @"SuggestedCellIdentifier";
    }
    else{
        identifier = @"MerchantIdentifier";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(!merchantListing){
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(20, 0, tableView.frame.size.width, 20);
        myLabel.font = [UIFont fontWithName:@"Avenir Next Demi Bold" size:12.0f];
        myLabel.text = @"Suggested Searches";
        
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor colorWithRed:0.9254f green:0.9254f blue:0.9254f alpha:1.0f];
        [headerView addSubview:myLabel];
        
        return headerView;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailSegue" sender:self];

}


@end

