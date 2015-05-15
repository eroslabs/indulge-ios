//
//  AddNewLookViewController.h
//  spalor
//
//  Created by Manish on 27/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface AddNewLookViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *addNewLookButton;
@property (nonatomic, strong) Deal *deal;
@end
