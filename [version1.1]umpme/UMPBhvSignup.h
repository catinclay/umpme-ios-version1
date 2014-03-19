//
//  UMPBhvSignup.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPLibApiManager.h"
#import "UMPCsntManager.h"

//@class UMPSignupViewController;

@interface UMPBhvSignup : NSObject

+ (id)shareSignupManager;

- (BOOL)userSignupWithEmail:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField withSignupError:(UILabel *)signupErrorLabel withPasswdRequirement:(UITextView *)passwdRequirementTextView;

@end
