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
    
    self.signupSucc = @"NO";
    
    // Get umpme behavior manager.
    UMPBhvManager *umpBhvManager = [UMPBhvManager shareBhvManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    BOOL signupSucc = [umpBhvManager.umpBhvSignup
                               userSignupWithEmail:self.uemailTextField
                               withConfirmEmail:self.uconfirmEmailTextField
                               withPasswd:self.upasswdTextField
                               withConfirmPasswd:self.uconfirmPasswdTextField
                               withSignupError:self.signupErrorLabel
                               withPasswdRequirement:self.passwdRequirementTextView];
    
    if (signupSucc) {
        [self performSegueWithIdentifier:umpCsntManager.umpCsntSegueManager.signupToLoginSuccessfully
                                  sender:self];
        NSLog(@"[debug][signup vc] yes");
    } else {
        NSLog(@"[debug][signup vc] no");
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
        UMPLoginViewController *tempLoginVC = [segue destinationViewController];
        tempLoginVC.uemailTextField.text = self.uemailTextField.text;
        tempLoginVC.upasswdTextField.text = self.upasswdTextField.text;
    }
}








@end
