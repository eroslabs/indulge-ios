//
//  MerchantPriceRangeCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantPriceRangeCell.h"
#import "MerchantService.h"

@implementation MerchantPriceRangeCell
-(MerchantPriceRangeCell *)setupWithMerchant:(Merchant *)merchant{
    
    
    self.priceRangeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"merchant-rupee%d.png",merchant.luxuryRating.intValue+1]];
    for(int i = 0 ;i < merchant.services.count ; i++){
        MerchantService *service = merchant.services[i];
        CGFloat priceValue = 0;
        if (![service.price isKindOfClass:[NSNull class]]) {
            priceValue = service.price.floatValue;

        }
        
        DLog(@"service %@ %.2f",service.name,priceValue);

        if(i==0)
            self.deal1.text = [NSString stringWithFormat:@"%@ at %.2f",service.name,priceValue];
        if(i==1)
            self.deal2.text = [NSString stringWithFormat:@"%@ at %.2f",service.name, priceValue];
        if(i==2)
            self.deal3.text = [NSString stringWithFormat:@"%@ at %.2f",service.name, priceValue];
    }
    return self;
}
@end
