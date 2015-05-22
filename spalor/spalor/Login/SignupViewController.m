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
#import "NetworkHelper.h"
#import "User.h"

@interface SignupViewController (){
    NSArray *dataSourceArray;
    NSArray *imagesArray;
    NSInteger selected;
    NSMutableDictionary *userDict;
    User *user;
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
    userDict = [NSMutableDictionary new];
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

#pragma mark - User Actons

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

-(IBAction)signup:(id)sender{
    
    if ([userDict allKeys].count <6) {
        return;
    }
    
    [[NetworkHelper sharedInstance] getArrayFromPostURL:@"user/save" parmeters:@{@"user":userDict} completionHandler:^(id response, NSString *url, NSError *error){
        if (error == nil && response!=nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
            
            NSLog(@"response string %@",responseDict);
            user = [[User alloc] init];
            user.userId = responseDict[@"user_id"];
            user.name = userDict[@"name"];
            user.mail = userDict[@"mail"];
            user.dob = userDict[@"dob"];
            user.rating = userDict[@"rating"];
            user.mobile = userDict[@"mobile"];
            NSData *archivedUser = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:archivedUser forKey:MYUSERSTORE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
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
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    NSString *base64StringOf_my_image = [self encodeBase64WithData:imageData];
    [userDict addEntriesFromDictionary:@{@"image":base64StringOf_my_image}];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

static const char base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

-(NSString *)encodeBase64WithData:(NSData *)objData {
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Create result NSString object
    NSString *base64String = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    
    // Free memory
    free(strResult);
    
    return base64String;
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
            [cell.cellInputTextField becomeFirstResponder];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (selected != -1) {
        FormInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selected inSection:0]];
        cell.cellIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imagesArray[selected]]];
        cell.cellInputTextField.textColor = [UIColor colorWithRed:0.8667f green:0.7960f blue:0.7411f alpha:1.0f];
        [cell.cellInputTextField resignFirstResponder];
    }
    
    selected = textField.tag;
    NSLog(@"selected %d",selected);
    FormInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selected inSection:0]];
    cell.cellIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-active.png",imagesArray[selected]]];
    cell.cellInputTextField.textColor = [UIColor colorWithRed:0.4431f green:0.3725f blue:0.3450f alpha:1.0f];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selected inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //[self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    selected = textField.tag;
    NSString *finalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    dataSourceArray = @[@"Full Name",@"Email",@"Mobile Number",@"Password",@"Confirm Password",@"Age",@"Gender"];

    switch (selected) {
        case 0:{
            if ([finalText isEqualToString:@""]) {
                [userDict removeObjectForKey:@"name"];
            }
            [userDict addEntriesFromDictionary:@{@"name":finalText}];
            break;
        }
        case 1:{
            if ([finalText isEqualToString:@""]) {
                [userDict removeObjectForKey:@"mail"];
            }
            [userDict addEntriesFromDictionary:@{@"mail":finalText}];
            break;
        }
        case 2:{
            if ([finalText isEqualToString:@""]) {
                [userDict removeObjectForKey:@"mobile"];
            }
            [userDict addEntriesFromDictionary:@{@"mobile":finalText}];
            break;
        }
        case 3:{
            if ([finalText isEqualToString:@""]) {
                [userDict removeObjectForKey:@"passphrase"];
            }
            [userDict addEntriesFromDictionary:@{@"passphrase":finalText}];
            break;
        }
        case 4:{
            if ([finalText isEqualToString:@""]) {
                [userDict removeObjectForKey:@"passphrase"];
            }
            [userDict addEntriesFromDictionary:@{@"passphrase":finalText}];
            break;
        }
        case 5:{
            if ([finalText isEqualToString:@""]) {
                [userDict removeObjectForKey:@"dob"];
            }
            [userDict addEntriesFromDictionary:@{@"dob":finalText}];
            break;
        }
        case 6:{
            if ([finalText isEqualToString:@""]) {
                [userDict removeObjectForKey:@"gender"];
            }
            [userDict addEntriesFromDictionary:@{@"gender":finalText}];
            break;
        }
        default:
            break;
    }
    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    selected = -1;
//    [self.tableView reloadData];
//    [textField resignFirstResponder];
//    return YES;
//}

@end
