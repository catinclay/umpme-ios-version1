//
//  UMPViewController.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPViewController.h"
#import "UMPLibApiManager.h"

@interface UMPViewController ()

@end

@implementation UMPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    BOOL is_autologin_succ = NO;
    UMPBhvManager *umpBhvManager = [UMPBhvManager shareBhvManager];
    NSDictionary *checkBackDic = [umpBhvManager.umpBhvAutoLogin checkLocalAutoLoginFlag];
    if (checkBackDic != nil) {
        NSDictionary *talkToServerBackDic = [umpBhvManager.umpBhvAutoLogin talkToServerToLoginWithDataDic:checkBackDic];
        if (talkToServerBackDic != nil) {
            NSString *uid = [talkToServerBackDic objectForKey:@"uid"];
            if ([umpBhvManager.umpBhvAutoLogin updateLocalLoginTableWithDataDic:talkToServerBackDic]) {
                if ([umpBhvManager.umpBhvAutoLogin
                     downloadAndWriteUnreadIntMsgToLocalDBForUid:uid]) {
                    if ([umpBhvManager.umpBhvAutoLogin initCurrUserInfo]) {
                        if ([umpBhvManager.umpBhvAutoLogin connectIntMsgServiceForUid:uid]) {
                            // Auto login successfully.
                            is_autologin_succ = YES;
                            // Go to main tbc.
                            [self performSegueWithIdentifier:umpCsntManager.umpCsntSegueManager.autoLoginToMainTBC sender:self];
                        }
                    }
                }
            }
        }
    }
    
    if (!is_autologin_succ) {
        // Go to login vc.
        [self performSegueWithIdentifier:umpCsntManager.umpCsntSegueManager.autoLoginToLogin sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Shut down screen auto rotate.
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end









