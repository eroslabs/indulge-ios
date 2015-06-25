//
//  AppDelegate.m
//  spalor
//
//  Created by Manish on 02/02/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "NetworkHelper.h"
#import "UIColor+flat.h"
#import "LocationHelper.h"
#import "CustomTabbarController.h"
static NSString * const kClientId = @"93816802333-n1e12l22i9o96ggukhjdh05ldes3738a.apps.googleusercontent.com";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];


    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunched"]){
        [[NSUserDefaults standardUserDefaults] setObject:@{@"hs":@"0",@"services":@"",@"page":@"0",@"limit":@"20",@"sort":@"distance",@"dir":@"asc",@"pt":@"20000",@"gs":@"2"} forKey:@"filterDict"];
        //[[NSUserDefaults standardUserDefaults] setObject:@{@"services":@"",@"page":@"0",@"limit":@"20"} forKey:@"filterDict"];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadCategories];
    }
    
    [self loadStates];
    
    return YES;
}

-(void)startLocationManager{
    if(self.locationManager == nil){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

    }
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

-(void)setTabbarItems{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomTabbarController *tabBarController=(CustomTabbarController *)[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];

    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];

    [UITabBarItem.appearance setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName : [UIColor whiteColor] }     forState:UIControlStateSelected];

    item0 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"navbar-home.png"] selectedImage:[UIImage imageNamed:@"navbar-home-active.png"]];
    item1 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"navbar-home.png"] selectedImage:[UIImage imageNamed:@"navbar-home-active.png"]];
    item2 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"navbar-home.png"] selectedImage:[UIImage imageNamed:@"navbar-home-active.png"]];
    item3 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"navbar-home.png"] selectedImage:[UIImage imageNamed:@"navbar-home-active.png"]];
    item4 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"navbar-home.png"] selectedImage:[UIImage imageNamed:@"navbar-home-active.png"]];

    tabBarController.selectedIndex=0;
}

-(void)loadCategories{
    
    //    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/suggestMerchant" withParameters:@{@"s":@"abc"} completionHandler:^(id response, NSString *url, NSError *error){
    
    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/loadCategories" withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error){
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"CategoryResponse"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"CategoryUpdateDate"];
        }
        else{
            NSLog(@"error %@",[error localizedDescription]);
        }
        
    }];
    
    
    
}

-(void)loadStates{

    [[NetworkHelper sharedInstance] getArrayFromGetUrl:@"search/loadStates" withParameters:@{} completionHandler:^(id response, NSString *url, NSError *error) {
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            NSMutableArray *data = [NSMutableArray new];

            for(NSDictionary *stateObj in responseDict[@"states"]){
                if([[stateObj objectForKey:@"status"] isEqual:@(1)]){
                    [data addObject:stateObj];
                }
            }
            
            if(data.count>0){
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"STATELIST"];
            }
        }
    }];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppEvents activateApp];
    [[LocationHelper sharedInstance] startLocationManager];

    BOOL authenticated = [[NSUserDefaults standardUserDefaults] boolForKey:@"AUTHENTICATED"];
    
    if(authenticated)  // authenticated---> BOOL Value assign True only if Login Success
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AUTHENTICATED"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CustomTabbarController *obj=(CustomTabbarController *)[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
        UINavigationController *navigationController=(UINavigationController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
        navigationController.navigationBarHidden=YES;
        [navigationController pushViewController:obj animated:NO];
    }

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation] || [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Location Manager Delegates

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusDenied){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"locationEnabled"];
        //Show status
    }
    if(IS_OS_8_OR_LATER) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager startUpdatingLocation];
            }
            
        }
        
    }
    else{
        [self.locationManager startUpdatingLocation];
        
    }
    
}


-(CLLocation *)getCurrentLocation{
    CLLocation *lastSavedLocation = [NSKeyedUnarchiver unarchiveObjectWithFile:[self lastLocationPersistenceFilePath]];
 
    if(lastSavedLocation == nil){
        if(self.locationManager.location == nil){
            return nil;
        }
        else{
            return self.locationManager.location;
        }
    }
    
    return lastSavedLocation;
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
    
    CLLocation *currentLocation = [self getCurrentLocation];
    CLLocation *fetchedLocation = [locations lastObject];
    if(currentLocation == nil){
        if([locations count]> 0) {
            [self persistLastLocation:[locations lastObject]];
        }
    }
    else if((currentLocation.coordinate.latitude == fetchedLocation.coordinate.latitude) && (currentLocation.coordinate.longitude == fetchedLocation.coordinate.longitude)){
        // Do Nothing
    }
    else{
        [self persistLastLocation:[locations lastObject]];

    }
    
}


@end
