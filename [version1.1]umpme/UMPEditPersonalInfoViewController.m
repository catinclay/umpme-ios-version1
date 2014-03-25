//
//  UMPEditPersonalInfoViewController.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPEditPersonalInfoViewController.h"

@interface UMPEditPersonalInfoViewController ()

@end

@implementation UMPEditPersonalInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_saveEditedPersonal addTarget:self action:@selector(editDone) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)editDone{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)takePhoto:(UIButton *)sender {
    
    BOOL cameraAvailabe = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    BOOL frontCarmeraAvailabe = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (cameraAvailabe || frontCarmeraAvailabe){
        
        UIImagePickerController *take = [[UIImagePickerController alloc] init];
        take.delegate = self;
        take.allowsEditing = YES;
        take.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:take animated:YES completion:NULL];
    }
    
    else{
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Camera has not been set up!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [cameraAlert show];
        
    }

}

- (IBAction)choosePhoto:(UIButton *)sender {
    UIImagePickerController *choose = [[UIImagePickerController alloc] init];
    
    choose.delegate = self;
    choose.allowsEditing = YES;
    choose.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:choose animated:YES completion:NULL];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenphoto = info[UIImagePickerControllerEditedImage];
    [self.myImage setImage:chosenphoto];
    
    self.myImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveEditedPersonal:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    
    NSString *uid = umpCacheManager.umpCurrUser.currUid;
    
    BOOL uploadBothSizeImagesBoolFlag = [umpApiManager.umpImage
                                         uploadImagesOfBothSizeWithSourceImage:self.myImage.image
                                         withBigImageCompressionQuality:0.5f
                                         withSmallImageCompressionQuality:0.1f
                                         forUid:uid
                                         withService:umpCsntManager.umpCsntNetworkManager.umpServiceUploadProfileImage];
    if (uploadBothSizeImagesBoolFlag) NSLog(@"upload successfully.");
    else NSLog(@"upload unsuccessully.");

}
@end
