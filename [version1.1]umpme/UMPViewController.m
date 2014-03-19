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




// Temp Action:
- (IBAction)AutoLoginAction:(id)sender {
    [self performSegueWithIdentifier:@"segue_autologinvc_to_maintbc" sender:self];
}

- (IBAction)autoLoginFailAction:(id)sender {
    [self performSegueWithIdentifier:@"segue_autologinvc_to_loginvc" sender:self];
}

// Only be used once by developer.
- (IBAction)createAutoLoginDBAndTable:(id)sender {
//    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
//    
//
//    [umpApiManager.umpLocalDB createLocalDB];
//    [umpApiManager.umpLocalDB openLocalDB];
//    
//    // Table: autologin
//    NSString *createAutoLoginTableSQL = @"CREATE TABLE IF NOT EXISTS autologin (uid INTEGER PRIMARY KEY, autologin_token TEXT, token_update_date TEXT, token_update_time TEXT, allow_autologin INTEGER, is_sync INTEGER)";
//    
//    [umpApiManager.umpLocalDB createTableOnLocalDB:createAutoLoginTableSQL];
//    [umpApiManager.umpLocalDB closeLocalDB];
}
@end









