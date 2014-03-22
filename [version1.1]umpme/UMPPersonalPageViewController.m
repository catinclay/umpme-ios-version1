//
//  UMPPersonalPageViewController.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPPersonalPageViewController.h"

@interface UMPPersonalPageViewController ()

@end

@implementation UMPPersonalPageViewController

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


// Shut down screen auto rotate.
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



// Temp Action:
- (IBAction)signoutAction:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPBhvManager *umpBhvManager = [UMPBhvManager shareBhvManager];
    
    // Get current user uid.
    NSString *uid = [umpApiManager.umpExtractDataFromLocalDB getCurrUserUid];
    NSString *server_login_id = [umpApiManager.umpExtractDataFromLocalDB getCurrLoginServerId];
    if (uid != nil && server_login_id != nil) {
        if ([umpBhvManager.umpBhvSignout talkToServerSignoutForUid:uid andServerLoginId:server_login_id]) {
            if ([umpBhvManager.umpBhvSignout disconnectIntMsgServiceForUid:uid]) {
                if ([umpBhvManager.umpBhvSignout clearAutoLoginTableForCurrUser]) {
                    if ([umpBhvManager.umpBhvSignout dropLocalUserCacheTables]) {
                        // Go back to login vc.
                        [self performSegueWithIdentifier:@"segue_personalpagevc_to_loginvc" sender:self];
                    }
                }
            }
        }
    }
}



- (IBAction)clearImagesAction:(id)sender {
    
    self.bigImageView.image = nil;
    self.smallImageView.image = nil;
}

- (IBAction)uploadImageAction:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = @"44";
    
    BOOL uploadBothSizeImagesBoolFlag = [umpApiManager.umpImage
                                         uploadImagesOfBothSizeWithSourceImage:self.mainImageView.image
                                         withBigImageCompressionQualityDic:0.5f
                                         withSmallImageCompressionQuality:0.1f
                                         forUid:uid
                                         withService:@"uploadprofileimage"];
    if (uploadBothSizeImagesBoolFlag) NSLog(@"upload successfully.");
    else NSLog(@"upload unsuccessully.");
    
}

- (IBAction)downloadBothAction:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = @"44";
    
    NSDictionary *imagesDic = [umpApiManager.umpImage downloadImageOfBothSizeForUid:uid withService:@"downloadbothsizeprofileimages"];
    if (imagesDic == nil) {
        NSLog(@"[debug][error][personal page vc]download nothing...");
    } else {
        NSData *bigImageData = [imagesDic objectForKey:@"ubigimagedata"];
        NSData *smallImageData = [imagesDic objectForKey:@"usmallimagedata"];
        self.bigImageView.image = [[UIImage alloc] initWithData:bigImageData];
        self.smallImageView.image = [[UIImage alloc] initWithData:smallImageData];
    }
    
}

- (IBAction)downloadBigAction:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = @"44";
    
    self.bigImageView.image = [umpApiManager.umpImage downloadSingleImageForUid:uid withService:@"downloadbigprofileimage"];
    
}

- (IBAction)downloadSmallAction:(id)sender {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = @"44";
    
    self.smallImageView.image = [umpApiManager.umpImage downloadSingleImageForUid:uid withService:@"downloadsmallprofileimage"];
    
}
@end





















