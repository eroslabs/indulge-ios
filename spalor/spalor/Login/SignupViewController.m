//
//  SignupViewController.m
//  spalor
//
//  Created by Manish on 09/02/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "SignupViewController.h"
#import "UIImage+ImageEffects.h"
#import "FormInputCell.h"

@interface SignupViewController (){
    NSArray *dataSourceArray;
    NSArray *imagesArray;
    NSInteger selected;
}
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [self.backgroundImageView.image applyCustomEffectWithWhite:0.5 andAlpha:0.3];
    self.profilebackgroundView.alpha = 0.5;
    self.profilebackgroundView.layer.cornerRadius = 50;
    self.profilebackgroundView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 50;
    self.profileImageView.clipsToBounds = YES;
    
    selected = -1;
    dataSourceArray = @[@"Full Name",@"Email",@"Mobile Number",@"Password",@"Confirm Password",@"Age",@"Gender"];
    imagesArray = @[@"registration-profile",@"registration-email",@"registration-mobile",@"registration-password",@"registration-password",@"registration-age",@"registration-gender"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)showImagePickerOptionsActionSheet:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick Image From"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Gallery", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    //0 is camera and 1 is gallery
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    
    if (buttonIndex == 0) {
        //Camera
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    }
    else if(buttonIndex == 1){
        // Gallery
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    else{
        return;
    }
    

    [self presentViewController:picker animated:YES completion:NULL];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark UITableViewDatasource


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = 9;
    return numOfRows;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<7){
        FormInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"formCell"];

        //cell.textLabel.text = @"Sample";
        cell.cellIconImageView.image = [UIImage imageNamed:@""];
        
        cell.cellInputTextField.placeholder = dataSourceArray[indexPath.row];
        cell.cellInputTextField.tag = indexPath.row;
        cell.cellInputTextField.delegate = self;
        if (indexPath.row == selected) {
            cell.cellIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-active.png",imagesArray[indexPath.row]]];
            cell.cellInputTextField.textColor = [UIColor colorWithRed:0.4431f green:0.3725f blue:0.3450f alpha:1.0f];

        }
        else{
            cell.cellIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imagesArray[indexPath.row]]];
            cell.cellInputTextField.textColor = [UIColor colorWithRed:0.8667f green:0.7960f blue:0.7411f alpha:1.0f];


        }
        return cell;

    }
    else{
        
        if(indexPath.row == 7){
            FormInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefCodeCell"];
            cell.cellNameLabel.text = @"Ref. Code";
            return cell;

        }
        else{
            FormInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcceptTermsCell"];
            cell.cellNameLabel.text = @"Accept Terms and Conditions";
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
 
    selected = textField.tag;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selected inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    selected = -1;
    [self.tableView reloadData];
    [textField resignFirstResponder];
    return YES;
}

@end
