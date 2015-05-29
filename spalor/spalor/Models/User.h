//
//  User.h
//  spalor
//
//  Created by Manish on 06/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *googleId;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *reviews;
@property (nonatomic, strong) NSString *looks;
@property (nonatomic, strong) NSString *deals;
@property (nonatomic, strong) NSString *merchants;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong) NSMutableArray *arrayOfReviews;


- (void)readFromDictionary:(NSDictionary *)dictionary;
- (void)saveArchivedUserData:(NSData *)userData;

@end
