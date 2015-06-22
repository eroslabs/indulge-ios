//
//  AllDealsViewController.m
//  spalor
//
//  Created by Manish on 13/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "AllDealsViewController.h"
#import "Deal.h"
#import "MyCouponCollectionViewCell.h"
#import "MyDealCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Deal.h"

@interface AllDealsViewController (){
    BOOL showActiveDeals;
    NSMutableArray *activeDealsArray;
    NSMutableArray *pastDealsArray;
}

@end

@implementation AllDealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    showActiveDeals = YES;
    self.activeDealsButton.selected = YES;
    self.pastDealsButton.selected = NO;
    [self setActiveandPastDealsDataSource];
    
}

-(void)setActiveandPastDealsDataSource{
    activeDealsArray = [NSMutableArray new];
    pastDealsArray = [NSMutableArray new];
    
    for(NSData *data in self.dataArray){
        Deal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(deal.validTill.length == 0){
            //Recurring
            [activeDealsArray addObject:deal];
        }
        else{
            double timeStampFromJSON = deal.validTill.doubleValue; // or whatever from your JSON
            double dif = timeStampFromJSON - [[NSDate date] timeIntervalSince1970];
            NSLog(@"dif: %f", dif);
            if(dif>0){
                [activeDealsArray addObject:deal];
            }
            else{
                [pastDealsArray addObject:deal];
            }
        }
        
    }
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View DataSource and Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return (showActiveDeals)?activeDealsArray.count:pastDealsArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Deal *deal = (showActiveDeals)?activeDealsArray[indexPath.row]:pastDealsArray[indexPath.row];
    
    if(deal.couponCode.length>0){
        NSLog(@"favourite deal %@ %@",deal.name,deal.couponCode);
        
        static NSString *cellIdentifier = @"myCouponsCell";
        
        MyCouponCollectionViewCell *cell = (MyCouponCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.backgroundImageView.image = [UIImage imageNamed:@"favourite-coupon.png"];
        cell.couponCodeLabel.text = deal.couponCode;
        cell.merchantNameLabel.text = deal.name;
        NSMutableString *servicesString = [[NSMutableString alloc] initWithString:@""];
        for(MerchantService *service in deal.services){
            [servicesString appendFormat:service.name];
            [servicesString appendFormat:@", "];
        }
        cell.merchantServicesLabel.text = servicesString;
        
        double unixTimeStamp = [deal.validTill doubleValue];
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setLocale:[NSLocale currentLocale]];
        [_formatter setDateFormat:@"dd.MM.yyyy"];
        NSString *validTilldate=[_formatter stringFromDate:date];
        
        cell.validTillLabel.text = [NSString stringWithFormat:@"Valid till %@",validTilldate];
        cell.discountLabel.text = (deal.percentOff)?[NSString stringWithFormat:@"%@%% off",deal.percentOff]:[NSString stringWithFormat:@"%@Rs off",deal.flatOff];
        return cell;
        
    }
    else{
        NSLog(@"favourite deal %@ %@",deal.name,deal.couponCode);
        
        static NSString *cellIdentifier = @"myDealsCell";
        
        MyDealCollectionViewCell *cell = (MyDealCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        NSString *urlString = (deal.image.length)?[NSString stringWithFormat:@"%@%@",INDULGE_MERCHANT_IMAGE_BASE_URL,deal.image]:[NSString stringWithFormat:STATIC_IMAGE_SOURCE];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        [cell.merchantProfileImageView setImageWithURL:url
                                      placeholderImage:[UIImage imageNamed:@"placeholder1.png"] options:SDWebImageProgressiveDownload ];
        
        cell.backgroundImageView.image = [UIImage imageNamed:@"deal-coupon.png"];
        cell.merchantName.text = deal.name;
        cell.merchantAddress.text = deal.address;
        cell.merchantRatingLabel.text = deal.rating;
        if(deal.distanceFromCurrentLocation.floatValue == 0.0){
            cell.distanceLabel.hidden = YES;
            
        }
        else{
            NSString *distanceString = [NSString stringWithFormat:@"%.1f m",deal.distanceFromCurrentLocation.doubleValue];
            if(deal.distanceFromCurrentLocation.doubleValue > 1000){
                distanceString = [NSString stringWithFormat:@"%.1f km",deal.distanceFromCurrentLocation.doubleValue/1000];
            }
            cell.distanceLabel.text = distanceString;
            
            
        }
//        if (deal.serviceNames.length>0) {
//            cell.merchantServicesLabel.text = deal.serviceNames;
//            
//        }
//        else{
//            //Put category Image Views
//        }
        
        double unixTimeStamp = [deal.validTill doubleValue];
        NSTimeInterval _interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setLocale:[NSLocale currentLocale]];
        [_formatter setDateFormat:@"dd.MM.yyyy"];
        NSString *validTilldate=[_formatter stringFromDate:date];
        
        cell.validTillLabel.text = [NSString stringWithFormat:@"Valid till %@",validTilldate];
        cell.discountLabel.text = (deal.percentOff)?[NSString stringWithFormat:@"%@%% off",deal.percentOff]:[NSString stringWithFormat:@"%@Rs off",deal.flatOff];
        return cell;
        
    }
    
    return nil;
    
}



#pragma mark - User Action

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)switchTabsActiveorPast:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    
    if([senderButton isEqual:self.activeDealsButton]){
        showActiveDeals = YES;
        self.activeDealsButton.selected = YES;
        self.pastDealsButton.selected = NO;
    }
    else{
        
        showActiveDeals = NO;
        self.activeDealsButton.selected = NO;
        self.pastDealsButton.selected = YES;

    }
    
    [self.collectionView reloadData];
}

@end
