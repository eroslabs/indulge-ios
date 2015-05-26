//
//  MerchantDealCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantDealCell.h"
#import "Deal.h"
@implementation MerchantDealCell
-(MerchantDealCell *)setupWithMerchant:(Deal *)merchantDeal{
    self.amountOffLabel.text = (merchantDeal.percentOff)?[NSString stringWithFormat:@"%@%% off",merchantDeal.percentOff]:[NSString stringWithFormat:@"%@Rs off",merchantDeal.flatOff];
    self.servicesLabel.text = [merchantDeal.serviceNames componentsJoinedByString:@","];
    double unixTimeStamp = [merchantDeal.validTill doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *validTilldate=[_formatter stringFromDate:date];
    
    self.validTillLabel.text = [NSString stringWithFormat:@"Valid till %@",validTilldate];

    return self;
}

-(MerchantDealCell *)setupWitDefault{
    self.amountOffLabel.text = @"500 Rs";
    self.servicesLabel.text = @"Hair Cut and Blow Dry";
    self.validTillLabel.text = @"Valid till 5th June 2015";
    return self;
}
@end
