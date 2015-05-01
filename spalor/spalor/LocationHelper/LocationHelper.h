//
//  LocationHelper.h
//  spalor
//
//  Created by Manish on 22/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationHelper : CLLocationManager<CLLocationManagerDelegate>
+ (LocationHelper *)sharedInstance;
- (void)startLocationManager;
- (void)stopLocationManager;
- (NSString *)deviceLocation;
- (BOOL)checkPermission;
- (NSArray *)deviceLocationArray;
- (CLLocation *)getCurrentLocation;
- (void)updateMyLocationtoServer;
- (CLLocationDistance)distanceInmeteresFrom:(CLLocation *)location;
@end

