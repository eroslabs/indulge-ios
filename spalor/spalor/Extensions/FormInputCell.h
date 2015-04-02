//
//  FormInputCell.h
//  spalor
//
//  Created by Manish on 02/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *cellInputTextField;
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellCTA;

@end
