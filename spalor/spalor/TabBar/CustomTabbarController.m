//
//  CustomTabbarController.m
//  Thrill
//
//  Created by Manish on 02/06/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "CustomTabbarController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIColor+flat.h"

#define TABBAR_HEIGHT (49)

@interface CustomTabbarController (){
    BOOL newMessageStateon;
}

@end

@implementation CustomTabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexCode:@"#715F58"]];

    UITabBar *tabBar = self.tabBar;
    
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
    
    [UITabBarItem.appearance setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName : [UIColor whiteColor] }     forState:UIControlStateSelected];
    
    item0.selectedImage = [[UIImage imageNamed:@"navbar-home-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    item1.selectedImage = [[UIImage imageNamed:@"navbar-nearby-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"navbar-deals-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"navbar-favourites-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"navbar-me-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
}

-(void)switchtoinbox{
    [self setSelectedIndex:3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
*/

// called when a new view is selected by the user (but not programatically)
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    
	if ( [self.view.subviews count] < 2 )
		return;
	
    if (self.selectedIndex == 2) {
        hidden = NO;
    }
    
	UIView *contentView;
    
	if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
		contentView = [self.view.subviews objectAtIndex:1];
	else
		contentView = [self.view.subviews objectAtIndex:0];
	
    
    if(hidden)
    {
        if(animated)
        {
            NSLog(@"HIDDEN - ANIMATED");
            self.isHidden = YES;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 contentView.frame = self.view.bounds;
                                 
                                 self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }
                             completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }];
        }
        else
        {
            NSLog(@"HIDDEN");
            self.isHidden = YES;
            
            contentView.frame = self.view.bounds;
            
            self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.size.height,
                                           self.view.bounds.size.width,
                                           TABBAR_HEIGHT);
        }
    }
    else
    {
        self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.size.height,
                                       self.view.bounds.size.width,
                                       0);
        if(animated)
        {
            NSLog(@"NOT HIDDEN - ANIMATED");
            self.isHidden = NO;
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height - TABBAR_HEIGHT,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }   completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.origin.y,
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height - TABBAR_HEIGHT);
                             }];
        }
        else
        {
            NSLog(@"NOT HIDDEN");
            self.isHidden = NO;
            
            contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.origin.y,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - TABBAR_HEIGHT);
            
            self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.size.height - TABBAR_HEIGHT,
                                           self.view.bounds.size.width,
                                           TABBAR_HEIGHT);
        }
    }
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated withCompletionBlock:(void (^)(void))completion
{
    NSLog(@"setTabBarHidden:%d animated:%d", hidden, animated);
    
    if ( [self.view.subviews count] < 2)
		return;
    
    if (self.selectedIndex == 2) {
        hidden = NO;
    }
	
	UIView *contentView;
    
	if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
		contentView = [self.view.subviews objectAtIndex:1];
	else
		contentView = [self.view.subviews objectAtIndex:0];
	
    
    if(hidden)
    {
        if(animated)
        {
            NSLog(@"HIDDEN - ANIMATED");
            self.isHidden = YES;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 contentView.frame = self.view.bounds;
                                 
                                 self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }
                             completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                                 
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
        else
        {
            NSLog(@"HIDDEN");
            self.isHidden = YES;
            
            contentView.frame = self.view.bounds;
            
            self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.size.height,
                                           self.view.bounds.size.width,
                                           TABBAR_HEIGHT);
            if (completion) {
                completion();
            }
        }
    }
    else
    {
        self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.size.height,
                                       self.view.bounds.size.width,
                                       0);
        if(animated)
        {
            NSLog(@"NOT HIDDEN - ANIMATED");
            self.isHidden = NO;
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height - TABBAR_HEIGHT,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }   completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.origin.y,
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height - TABBAR_HEIGHT);
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
        else
        {
            NSLog(@"NOT HIDDEN");
            self.isHidden = NO;
            
            contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.origin.y,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - TABBAR_HEIGHT);
            
            self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.size.height - TABBAR_HEIGHT,
                                           self.view.bounds.size.width,
                                           TABBAR_HEIGHT);
            if (completion) {
                completion();
            }
        }
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self playSound];
    NSLog(@"tab changed");
    //[self setTabBarHidden:NO animated:NO];
}

-(void) playSound {
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"TabBarSound" ofType:@"wav"];
//    SystemSoundID soundID;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
//    
//    AudioServicesPlaySystemSound (soundID);
    //[soundPath release];
}




-(void)dealloc{
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
