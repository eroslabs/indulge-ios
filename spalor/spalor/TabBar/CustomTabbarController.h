//
//  CustomTabbarController.h
//  Thrill
//
//  Created by Manish on 02/06/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabbarController : UITabBarController<UITabBarDelegate>

@property (nonatomic, weak) IBOutlet UITabBarItem *homeItem;
@property BOOL isHidden;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated withCompletionBlock:(void (^)(void))completion;
- (void)userLoggedOut;
-(void)changeBottomTabbarIconForMessageBacktoNormal;
-(void)changeBottomTabBarIconToNewMessageState;
@end