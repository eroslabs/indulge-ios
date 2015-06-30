//
//  MyLook.m
//  spalor
//
//  Created by Manish on 15/05/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "MyLook.h"

@implementation MyLook
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.merchantName = [decoder decodeObjectForKey:@"merchantName"];
        self.merchantAddress = [decoder decodeObjectForKey:@"merchantAddress"];
        self.merchantRating = [decoder decodeObjectForKey:@"merchantRating"];
        self.merchantService = [decoder decodeObjectForKey:@"merchantService"];
        self.imageData = [decoder decodeObjectForKey:@"imageData"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.merchantPhone = [decoder decodeObjectForKey:@"merchantPhone"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_merchantName forKey:@"merchantName"];
    [encoder encodeObject:_merchantAddress forKey:@"merchantAddress"];
    [encoder encodeObject:_merchantRating forKey:@"merchantRating"];
    [encoder encodeObject:_merchantService forKey:@"merchantService"];
    [encoder encodeObject:_imageData forKey:@"imageData"];
    [encoder encodeObject:_date forKey:@"date"];
    [encoder encodeObject:_merchantPhone forKey:@"merchantPhone"];
}
@end
