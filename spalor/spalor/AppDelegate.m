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
static NSString * const kClientId = @"93816802333-n1e12l22i9o96ggukhjdh05ldes3738a.apps.googleusercontent.com";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];
    return YES;
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

    BOOL authenticated = [[NSUserDefaults standardUserDefaults] boolForKey:@"AUTHENTICATED"];
    
    if(authenticated)  // authenticated---> BOOL Value assign True only if Login Success
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AUTHENTICATED"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
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


@end
