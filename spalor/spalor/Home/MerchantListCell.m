//
//  MerchantListCell.m
//  spalor
//
//  Created by Manish on 20/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantListCell.h"
#import "Merchant.h"

@implementation MerchantListCell

-(void)setServiceCategoryImagesWithMerchant:(Merchant *)merchant{
    
    NSArray *categoryMap = @[@"merchant-massage",@"merchant-makeup",@"merchant-nail",@"merchant-haircut",@"merchant-body",@"merchant-face",@"merchant-removal",@"merchant-pt",@"merchant-combo"];
    
    for(int index = 0;index<8;index++){
        
        NSString *imageName = [NSString stringWithFormat:@"%@.png",categoryMap[index]];
        NSString *selectedImageName = [NSString stringWithFormat:@"%@-deal.png",categoryMap[index]];

        switch(index){
            case 0:
                self.serviceCategoryImageView1.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 1:
                self.serviceCategoryImageView2.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 2:
                self.serviceCategoryImageView3.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 3:
                self.serviceCategoryImageView4.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 4:
                self.serviceCategoryImageView5.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 5:
                self.serviceCategoryImageView6.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 6:
                self.serviceCategoryImageView7.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 7:
                self.serviceCategoryImageView8.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            case 8:
                self.serviceCategoryImageView9.image = ([merchant.categoryIds containsObject:@(index+1)])?[UIImage imageNamed:selectedImageName]:[UIImage imageNamed:imageName];
                break;
            default:
                break;
        }
    }
}
@end
