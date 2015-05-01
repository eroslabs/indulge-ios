//
//  LocationHelper.m
//  spalor
//
//  Created by Manish on 22/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "LocationHelper.h"
#import <UIKit/UIKit.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LocationHelper(){
    
}

@end

@implementation LocationHelper

+(LocationHelper *)sharedInstance {
    static LocationHelper *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
        
    });
    return _sharedClient;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusDenied){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"locationEnabled"];
    }
    else{

        [self startUpdatingLocation];
    }
}

- (void)startLocationManager {
    if (self) {
        //[self stopUpdatingLocation];
        self.distanceFilter = 100;
        self.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.delegate = self;
        if(IS_OS_8_OR_LATER) {
            if ([self respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self requestWhenInUseAuthorization];
                [self startMonitoringSignificantLocationChanges];
                [self startUpdatingLocation];
                
            }
            
        }
        else{
            [self startUpdatingLocation];
            
        }
        
    }
    
}

- (void)stopLocationManager {
    self.delegate = nil;
    [self stopUpdatingLocation];
}


-(CLLocation *)getCurrentLocation{
    CLLocation *myLocation = [NSKeyedUnarchiver unarchiveObjectWithFile:[self lastLocationPersistenceFilePath]];
    if (myLocation) {
        return myLocation;
    }
    else{
        return nil;
    }

}

- (void)persistLastLocation:(CLLocation *)location {
    BOOL success = [NSKeyedArchiver archiveRootObject:location
                                               toFile:[self lastLocationPersistenceFilePath]];
    if (!success) {
        NSLog(@"Could not persist location for some reason!");
    }
    else{
        NSLog(@"last location saved");
    }
}
- (NSString *)lastLocationPersistenceFilePath {
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"my_app_last_location"];
    return filePath;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    if([locations count]> 0) {
        [self persistLastLocation:[locations lastObject]];
    }
}

-(BOOL)checkPermission {
    
    if(IS_OS_8_OR_LATER) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            return NO;
        }
        else{
            return YES;
        }
    }
}

- (CGFloat)distanceInmeteresFrom:(CLLocation *)location{
    CLLocation *currentlocation = [self getCurrentLocation];
    if (currentlocation) {
        CLLocationDistance distance = [location distanceFromLocation:currentlocation];
        return distance;
    }
    return -1.0;
}


-(void)dealloc{
    self.delegate = nil;
}




@end
