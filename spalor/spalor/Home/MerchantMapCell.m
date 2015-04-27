//
//  MerchantMapCell.m
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MerchantMapCell.h"

@implementation MerchantMapCell

-(MerchantMapCell *)setupWithMerchant:(Merchant *)merchant{
    CLLocationCoordinate2D coord = {.latitude =  merchant.geo.lat.floatValue, .longitude =  merchant.geo.lon.floatValue};
    MKCoordinateSpan span = {.latitudeDelta =  1, .longitudeDelta =  1};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [self.mapView addAnnotation:annotation];
    return self;
}
@end
