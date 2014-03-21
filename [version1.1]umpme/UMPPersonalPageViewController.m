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



@end





















