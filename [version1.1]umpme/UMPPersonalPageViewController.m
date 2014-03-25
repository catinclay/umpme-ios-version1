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

-(void) viewWillAppear:(BOOL)animated
{
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    
    NSString *uid = umpCacheManager.umpCurrUser.currUid;
    self.mainImageView.image = [umpApiManager.umpImage
                                downloadSingleImageForUid:uid
                                withService:umpCsntManager.umpCsntNetworkManager.umpServiceDownloadBigProfileImage];
    
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    // Get current user uid.
    NSString *uid = [umpApiManager.umpExtractDataFromLocalDB getCurrUserUid];
    NSString *server_login_id = [umpApiManager.umpExtractDataFromLocalDB getCurrLoginServerId];
    if (uid != nil && server_login_id != nil) {
        if ([umpBhvManager.umpBhvSignout talkToServerSignoutForUid:uid andServerLoginId:server_login_id]) {
            if ([umpBhvManager.umpBhvSignout disconnectIntMsgServiceForUid:uid]) {
                if ([umpBhvManager.umpBhvSignout clearAutoLoginTableForCurrUser]) {
                    if ([umpBhvManager.umpBhvSignout dropLocalUserCacheTables]) {
                        // Go back to login vc.
                        [self performSegueWithIdentifier:umpCsntManager.umpCsntSegueManager.personalPageToLogin sender:self];
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
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    
    NSString *uid = umpCacheManager.umpCurrUser.currUid;
    
    BOOL uploadBothSizeImagesBoolFlag = [umpApiManager.umpImage
                                         uploadImagesOfBothSizeWithSourceImage:self.mainImageView.image
                                         withBigImageCompressionQuality:0.5f
                                         withSmallImageCompressionQuality:0.1f
                                         forUid:uid
                                         withService:umpCsntManager.umpCsntNetworkManager.umpServiceUploadProfileImage];
    if (uploadBothSizeImagesBoolFlag) NSLog(@"upload successfully.");
    else NSLog(@"upload unsuccessully.");
    
}

//- (IBAction)downloadBothAction:(id)sender {
//    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
//    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
//    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
//    
//    NSString *uid = umpCacheManager.umpCurrUser.currUid;
//    
//    NSDictionary *imagesDic = [umpApiManager.umpImage
//                               downloadImageOfBothSizeForUid:uid
//                               withService:umpCsntManager.umpCsntNetworkManager.umpServiceDownloadBothSizeProfileImages];
//    if (imagesDic == nil) {
//        NSLog(@"[debug][error][personal page vc]download nothing...");
//    } else {
//        NSData *bigImageData = [imagesDic objectForKey:umpCsntManager.umpCsntImageManager.umpUBigImageData];
//        NSData *smallImageData = [imagesDic objectForKey:umpCsntManager.umpCsntImageManager.umpUSmallImageData];
//        self.bigImageView.image = [[UIImage alloc] initWithData:bigImageData];
//        self.smallImageView.image = [[UIImage alloc] initWithData:smallImageData];
//        self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.smallImageView.contentMode = UIViewContentModeScaleAspectFit;
//
//    }
//    
//}
//
//- (IBAction)downloadBigAction:(id)sender {
//    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
//    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
//    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
//    
//    NSString *uid = umpCacheManager.umpCurrUser.currUid;
//    self.bigImageView.image = [umpApiManager.umpImage
//                               downloadSingleImageForUid:uid
//                               withService:umpCsntManager.umpCsntNetworkManager.umpServiceDownloadBigProfileImage];
//    self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
//   
//    
//}
//
//- (IBAction)downloadSmallAction:(id)sender {
//    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
//    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
//    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
//    
//    NSString *uid = umpCacheManager.umpCurrUser.currUid;
//    
//    self.smallImageView.image = [umpApiManager.umpImage
//                                 downloadSingleImageForUid:uid
//                                 withService:umpCsntManager.umpCsntNetworkManager.umpServiceDownloadSmallProfileImage];
//    self.smallImageView.contentMode = UIViewContentModeScaleAspectFit;
//
//    
//}

- (IBAction)getFriendsIdsAction:(id)sender {
    
    UMPCacheManager *umpCacheManager = [UMPCacheManager shareCacheManager];
    NSArray *friendsIdsArray = umpCacheManager.umpCurrUser.friendsIdsArray;
    // Print the friends ids.
    NSInteger friends_num = [friendsIdsArray count];
    for (NSInteger i = 0; i < friends_num; i ++) {
        NSLog(@"[debug][personal page vc] friend id = %@", [friendsIdsArray objectAtIndex:i]);
    }
    
}

- (IBAction)editPersonalInfoAction:(id)sender {
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    [self performSegueWithIdentifier:umpCsntManager.umpCsntSegueManager.personalPageToEditPersonalInfo sender:self];
    
}
@end





















