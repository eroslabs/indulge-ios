//
//  DealPriceCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "DealPriceCell.h"
#import "MerchantService.h"

@implementation DealPriceCell
-(DealPriceCell *)setupCellWithDeal:(Deal *)deal{
    for(int i = 0 ;i < deal.services.count ; i++){
        MerchantService *service = deal.services[i];
        NSLog(@"service %@ %.2%f",service.name,service.price.floatValue);

        if(i==0)
            self.deal1.text = [NSString stringWithFormat:@"%@ at %.2f",service.name, service.price.floatValue];
        if(i==1)
            self.deal2.text = [NSString stringWithFormat:@"%@ at %.2f",service.name, service.price.floatValue];
        if(i==2)
            self.deal3.text = [NSString stringWithFormat:@"%@ at %.2f",service.name, service.price.floatValue];
    }

    return self;
}
@end
