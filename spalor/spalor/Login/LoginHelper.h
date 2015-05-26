//
//  LoginHelper.h
//  spalor
//
//  Created by Manish on 25/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface LoginHelper : NSObject
+ (LoginHelper *)sharedInstance;
- (void)loginToFacebookWithPermissions:(NSDictionary *)permissions;
- (void)userLoggedOut;
- (void)userLoggedInwithFBUserObject:(User *)user;
- (void)getUserProfileInfo;
- (void)checkServerSessionValidity;
- (void)checkServerSessionValidityFromDelegate;
- (void)connectWithFacebook;
@end
