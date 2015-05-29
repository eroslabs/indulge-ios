//
//  User.m
//  spalor
//
//  Created by Manish on 06/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.mail = [decoder decodeObjectForKey:@"email"];
        self.looks = [decoder decodeObjectForKey:@"looks"];
        self.deals = [decoder decodeObjectForKey:@"deals"];
        self.merchants = [decoder decodeObjectForKey:@"merchants"];
        self.reviews = [decoder decodeObjectForKey:@"reviews"];
        self.arrayOfReviews = [decoder decodeObjectForKey:@"arrayOfReviews"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.imageData = [decoder decodeObjectForKey:@"imageData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_mail forKey:@"email"];
    [encoder encodeObject:_looks forKey:@"looks"];
    [encoder encodeObject:_deals forKey:@"deals"];
    [encoder encodeObject:_merchants forKey:@"merchants"];
    [encoder encodeObject:_reviews forKey:@"reviews"];
    [encoder encodeObject:_arrayOfReviews forKey:@"arrayOfReviews"];
    [encoder encodeObject:_gender forKey:@"gender"];
    [encoder encodeObject:_imageData forKey:@"imageData"];
}

- (void)readFromDictionary:(NSDictionary *)dictionary{
    
    NSLog(@"user Dict %@",dictionary);
    
    for(NSString *key in [dictionary allKeys]){
        if([key isEqualToString:@"dob"]){
            self.dob = dictionary[key];
        }
        if([key isEqualToString:@"gender"]){
            self.gender = dictionary[key];
        }
        if([key isEqualToString:@"id"]){
            self.userId = dictionary[key];
        }
        if([key isEqualToString:@"mobile"]){
            self.mobile = dictionary[key];

        }
        if([key isEqualToString:@"mail"]){
            self.mail = dictionary[key];
        }
        if([key isEqualToString:@"name"]){
            self.name = dictionary[key];
        }
        if([key isEqualToString:@"facebook"]){
            self.facebookId = dictionary[key];
        }
        if([key isEqualToString:@"google"]){
            self.googleId = dictionary[key];
        }
        
    }
    
    self.reviews = @"0";
    self.deals = @"0";
    self.merchants = @"0";
    self.looks = @"0";

}

- (void)saveArchivedUserData:(NSData *)userData{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MYUSERSTORE];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:MYUSERSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


@end
