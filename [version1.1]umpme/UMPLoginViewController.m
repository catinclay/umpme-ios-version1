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
    //[self performSegueWithIdentifier:@"segue_loginvc_to_maintbc" sender:self];
    
    UMPBhvManager *umpBhvManager = [UMPBhvManager shareBhvManager];
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
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
                    NSLog(@"[debug][temp][login vc] uid = %@", backUid);
                    
                    // Sync auto login flag.
                    BOOL updateLocalAutoLoginFlagBoolFlag = [umpBhvManager.umpBhvLogin
                                                             updateLocalAutologinFlagForUid:backUid
                                                             basedOnSwitch:self.autoLoginSwitch];
                    
                    BOOL updateServerAutoLoginFlagBoolFlag = [umpBhvManager.umpBhvLogin
                                                              updateServerAutoLoginFlagForUid:backUid
                                                              basedOnSwitch:self.autoLoginSwitch];
                    
                    BOOL updateBothSidesAutoLoginBoolFlag = [umpApiManager.umpSyncBothSidesDB
                                                             syncBothSides_Update_AutoLoginForUid:backUid];
                    
                    
                    if (updateLocalAutoLoginFlagBoolFlag && updateServerAutoLoginFlagBoolFlag &&
                        updateBothSidesAutoLoginBoolFlag) {
                        
                        // Create local user cache tables.
                        if ([umpApiManager.umpLocalDB createUserLocalCacheTables]) {
                            
                            // Download "login signout data", and write them into local "login" table.
                            
                            
                        }
                        
                        
                    } else {
                    }

                } else {
                }
                
            } else {
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
