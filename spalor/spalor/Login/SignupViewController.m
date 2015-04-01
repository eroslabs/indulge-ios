//
//  SignupViewController.m
//  spalor
//
//  Created by Manish on 09/02/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

#import "SignupViewController.h"
#import "UIImage+ImageEffects.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [self.backgroundImageView.image applyCustomEffectWithWhite:0.5 andAlpha:0.3];
    self.profilebackgroundView.alpha = 0.5;
    self.profilebackgroundView.layer.cornerRadius = 40;
    self.profilebackgroundView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 40;
    self.profileImageView.clipsToBounds = YES;
    
    
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

- (IBAction)signup:(id)sender {

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AUTHENTICATED"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"TABBAR"];
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:obj animated:YES];
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

@end
