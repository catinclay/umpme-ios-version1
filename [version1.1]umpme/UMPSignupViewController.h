//
//  UMPSignupViewController.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMPBhvManager.h"
#import "UMPCsntManager.h"
#import "UMPLoginViewController.h"

@interface UMPSignupViewController : UIViewController


//@property (nonatomic, assign) id delegate;

// Temp Property:
@property (weak, nonatomic) IBOutlet UITextField *uemailTextField;
@property (weak, nonatomic) IBOutlet UITextField *uconfirmEmailTextField;

@property (weak, nonatomic) IBOutlet UITextField *upasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *uconfirmPasswdTextField;
@property (weak, nonatomic) IBOutlet UILabel *signupErrorLabel;
@property (weak, nonatomic) IBOutlet UITextView *passwdRequirementTextView;

@property (strong, nonatomic) NSString *signupSucc;

// Temp Action:
- (IBAction)signupAction:(id)sender;
- (IBAction)signupvcToLoginvcAction:(id)sender;

- (IBAction)hideKeyboard:(id)sender;



@end
