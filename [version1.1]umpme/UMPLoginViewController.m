//
//  UMPLoginViewController.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLoginViewController.h"

@interface UMPLoginViewController ()

@end

@implementation UMPLoginViewController

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
    if ([self.initialEmailText length] > 0 && [self.initialPasswdText length] > 0) {
        self.uemailTextField.text = self.initialEmailText;
        self.upasswdTextField.text = self.initialPasswdText;
    }
    
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
- (IBAction)loginAction:(id)sender {
    
    UMPBhvManager *umpBhvManager = [UMPBhvManager shareBhvManager];
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    [umpBhvManager.umpBhvLogin initStateForLoginErrorLabel:self.loginErrorLabel];
    if ([umpBhvManager.umpBhvLogin
         checkInputForEmail:self.uemailTextField
         andPasswd:self.upasswdTextField withLoginErrorLable:self.loginErrorLabel]) {
        NSDictionary *dealWithDataBackDataDic = [umpBhvManager.umpBhvLogin
                                                 dealWithInputWithEmail:self.uemailTextField
                                                 andPasswd:self.upasswdTextField];
        
        if (dealWithDataBackDataDic != nil) {
            NSDictionary *serverBackDataDic = [umpBhvManager.umpBhvLogin
                                               talkToServerWithDataDic:dealWithDataBackDataDic];
            
            if (serverBackDataDic != nil) {
                NSDictionary *analyzeBackDataDic = [umpBhvManager.umpBhvLogin
                                                    analyzeBackDataDic:serverBackDataDic
                                                    withEmailTextField:self.uemailTextField
                                                    andPasswdTextField:self.upasswdTextField
                                                    withLoginErrorLable:self.loginErrorLabel];
                
                if (analyzeBackDataDic != nil) {
                    NSString *backUid = [analyzeBackDataDic objectForKey:@"uid"];
                    
                    
                    // Deal with the case which recover from crash.
                    if ([umpBhvManager.umpBhvLogin dealWithRecoverFromCrash]) {
                        
                        BOOL updateServerAutoLoginFlagBoolFlag = [umpBhvManager.umpBhvLogin
                                                                  updateServerAutoLoginFlagForUid:backUid
                                                                  basedOnSwitch:self.autoLoginSwitch];
                        
                        BOOL writeAutoLoginInfoIntoLocalDBBoolFlag = [umpBhvManager.umpBhvLogin writeAutoLoginInfoIntoLocalDBForUid:backUid];
                        
                        
                        if (updateServerAutoLoginFlagBoolFlag && writeAutoLoginInfoIntoLocalDBBoolFlag) {
                            
                            // Create local user cache tables.
                            if ([umpApiManager.umpLocalDB createUserLocalCacheTables]) {
                                
                                // Download "login signout data", and write them into local "login" table.
                                NSDictionary *downloadLoginSignoutDataDic = [umpApiManager.umpDownloadData
                                                                             downloadLoginSignoutTableDataForUid:backUid];
                                if (downloadLoginSignoutDataDic != nil) {
                                    
                                    NSString *uid = [downloadLoginSignoutDataDic objectForKey:@"uid"];
                                    NSString *login_server_id = [downloadLoginSignoutDataDic objectForKey:@"login_server_id"];
                                    
                                    NSString *insertSQL = [[NSString alloc]
                                                           initWithFormat:@"INSERT INTO login (uid, login_id) VALUES (%@, %@)",
                                                           uid, login_server_id];
                                    
                                    if ([umpApiManager.umpLocalDB openLocalDB] &&
                                        [umpApiManager.umpLocalDB insertDataOnLocalDB:insertSQL] &&
                                        [umpApiManager.umpLocalDB closeLocalDB]) {
                                        
                                        if ([umpBhvManager.umpBhvLogin writeIntMsgDataIntoLocalIntMsgTableForUid:backUid]) {
                                            if ([umpBhvManager.umpBhvLogin initCurrUserInfo]) {
                                                if ([umpBhvManager.umpBhvLogin connectIntMsgServerForUid:backUid]) {
                                                    
                                                    // Login successfully.
                                                    
                                                    [self performSegueWithIdentifier:umpCsntManager.umpCsntSegueManager.loginToMainTBC
                                                                              sender:self];
                                                    
                                                    //////////////////////
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

- (IBAction)loginvcToSignupvcAction:(id)sender {
    [self performSegueWithIdentifier:@"segue_loginvc_to_signupvc" sender:self];
}

- (IBAction)hideKeyBoard:(id)sender {
    [self.uemailTextField resignFirstResponder];
    [self.upasswdTextField resignFirstResponder];
}




@end
