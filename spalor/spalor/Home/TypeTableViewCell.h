//
//  TypeTableViewCell.h
//  spalor
//
//  Created by Manish on 22/06/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *typeName;
@property (nonatomic, weak) IBOutlet UILabel *genderName;
@property (nonatomic, weak) IBOutlet UILabel *priceName;

@end
