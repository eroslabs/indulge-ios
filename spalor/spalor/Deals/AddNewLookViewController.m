//
//  AddNewLookViewController.m
//  spalor
//
//  Created by Manish on 27/04/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "AddNewLookViewController.h"

@implementation AddNewLookViewController

#pragma mark - User Actions

-(IBAction)share:(id)sender{
    
}

-(IBAction)skip:(id)sender{
    //Perform Segue
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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
    [self.addNewLookButton setImage:chosenImage forState:UIControlStateNormal];
    NSMutableArray *myLookBookImagesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"MyLookBookImages"]];
    [myLookBookImagesArray addObject: UIImagePNGRepresentation(chosenImage)];
    [[NSUserDefaults standardUserDefaults] setObject:myLookBookImagesArray forKey:@"MyLookBookImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



@end
