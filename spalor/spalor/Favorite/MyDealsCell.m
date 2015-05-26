//
//  MyDealsCell.m
//  spalor
//
//  Created by Manish on 28/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MyDealsCell.h"
#import "MyDealCollectionViewCell.h"
#import "MyCouponCollectionViewCell.h"
#import "Deal.h"
#import "MerchantService.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MyDealsCell
//-(void)setupCellWithMyDealImagesArray:(NSArray *)imagesArray{
//    int index = 0;
//    
//    for (NSData *imageData in imagesArray) {
//        UIView *couponView = [[UIView alloc] init];
//        UIImage *myImage = [UIImage imageWithData:imageData];
//        NSLog(@"image data %@",imageData);
//        UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
//        myImageView.backgroundColor = [UIColor colorWithRed:index*0.055f green:index*0.055f blue:index*0.055f alpha:1];
//        couponView.frame = CGRectMake(index*210 + 20, 20, 190, self.scrollView.frame.size.height-10);
//        index ++;
//
//        myImageView.frame = CGRectMake(0, 0, 190, couponView.frame.size.height);
//        
//        [couponView addSubview:myImageView];
//        index ++;
//        [self.scrollView addSubview:myImageView];
//    }
//    
//    [self.scrollView setContentSize:CGSizeMake((index)*210+20, self.scrollView.contentSize.height-10)];
//
//}

-(void)setupCellWithMyDealArray:(NSArray *)dataArray{
    self.dataArray = dataArray;
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setItemSize:CGSizeMake(290, 125)];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    
//    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView reloadData];
}

#pragma mark - Collection View DataSource and Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSData *data = [self.dataArray objectAtIndex:indexPath.section];
    
    Deal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(deal.couponCode.length>0){
        NSLog(@"favourite deal %@ %@",deal.name,deal.couponCode);
        
        static NSString *cellIdentifier = @"myCouponsCell";
        
        MyCouponCollectionViewCell *cell = (MyCouponCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.backgroundImageView.image = [UIImage imageNamed:@"favourite-coupon.png"];
        cell.couponCodeLabel.text = deal.name;
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
                
        if (deal.serviceNames.count>0) {
            cell.merchantServicesLabel.text = [deal.serviceNames componentsJoinedByString:@","];

        }
        else{
            //Put category Image Views
        }
        
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

@end
