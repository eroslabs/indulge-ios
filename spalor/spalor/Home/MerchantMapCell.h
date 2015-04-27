//
//  MerchantMapCell.h
//  spalor
//
//  Created by Manish on 24/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"
#import <MapKit/MapKit.h>

@interface MerchantMapCell : UITableViewCell
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
-(MerchantMapCell *)setupWithMerchant:(Merchant *)merchant;

@end
