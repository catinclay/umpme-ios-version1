//
//  UMPSignupViewController.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPSignupViewController.h"

@interface UMPSignupViewController ()

@end

@implementation UMPSignupViewController

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
- (IBAction)signupAction:(id)sender {
    
    // Get umpme behavior manager.
    UMPBhvManager *umpBhvManager = [UMPBhvManager shareBhvManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    [umpBhvManager.umpBhvSignup
     initStateForErrorLabel:self.signupErrorLabel
     andPasswdRequirementTextView:self.passwdRequirementTextView];
    
    NSDictionary *dealWithInputBackDataDic = [umpBhvManager.umpBhvSignup
                                              dealWithInput:self.uemailTextField
                                              withConfirmEmail:self.uconfirmEmailTextField
                                              withPasswd:self.upasswdTextField
                                              withConfirmPasswd:self.uconfirmPasswdTextField];
    
    BOOL checkInputWell = [umpBhvManager.umpBhvSignup
                           checkInputForDataDic:dealWithInputBackDataDic
                           withEmail:self.uemailTextField
                           withConfirmEmail:self.uconfirmEmailTextField
                           withPasswd:self.upasswdTextField
                           withConfirmPasswd:self.uconfirmPasswdTextField
                           withSignupError:self.signupErrorLabel
                           withPasswdRequirement:self.passwdRequirementTextView];
    
    if (checkInputWell) {
        NSDictionary *encodeInputBackDataDic = [umpBhvManager.umpBhvSignup
                                                encodeInputForDataDic:dealWithInputBackDataDic];

        NSDictionary *talkToServerBackDataDic = [umpBhvManager.umpBhvSignup
                                                 talkToServerWithDataDic:encodeInputBackDataDic];
        if (talkToServerBackDataDic != nil) {
            NSDictionary *analyzeBackDataDic = [umpBhvManager.umpBhvSignup
                                                analyzeServerBackDataWithDataDic:talkToServerBackDataDic
                                                withEmail:self.uemailTextField
                                                withConfirmEmail:self.uconfirmEmailTextField
                                                withPasswd:self.upasswdTextField
                                                withConfirmPasswd:self.uconfirmPasswdTextField
                                                withSignupError:self.signupErrorLabel
                                                withPasswdRequirement:self.passwdRequirementTextView];
            
            if (analyzeBackDataDic != nil) {
                [self
                 performSegueWithIdentifier:umpCsntManager.umpCsntSegueManager.signupToLoginSuccessfully
                 sender:self];
            }
        } else {
            self.signupErrorLabel.text = @"can not connect to Internet";
            self.signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
        }
    }
}

- (IBAction)signupvcToLoginvcAction:(id)sender {
    [self performSegueWithIdentifier:@"segue_signupvc_to_loginvc_general" sender:self];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.uemailTextField resignFirstResponder];
    [self.uconfirmEmailTextField resignFirstResponder];
    [self.upasswdTextField resignFirstResponder];
    [self.uconfirmPasswdTextField resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    if ([[segue identifier] isEqualToString:umpCsntManager.umpCsntSegueManager.signupToLoginSuccessfully]) {
        UMPLoginViewController *tempLoginVC = (UMPLoginViewController *)[segue destinationViewController];
        tempLoginVC.initialEmailText = self.uemailTextField.text;
        tempLoginVC.initialPasswdText = self.upasswdTextField.text;
    }
}








@end
