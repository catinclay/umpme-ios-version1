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


@interface UMPBhvSignup : NSObject

+ (id)shareSignupManager;

- (void)initStateForErrorLabel:(UILabel *)signupErrorLabel andPasswdRequirementTextView:(UITextView *)passwdRequirementTextView;

- (NSDictionary *)dealWithInput:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField;

- (BOOL)checkInputForDataDic:(NSDictionary *)dataDic withEmail:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField withSignupError:(UILabel *)signupErrorLabel withPasswdRequirement:(UITextView *)passwdRequirementTextView;

-(NSDictionary *)encodeInputForDataDic:(NSDictionary *)dataDic;

- (NSDictionary *)talkToServerWithDataDic:(NSDictionary *)dataDic;

- (NSDictionary *)analyzeServerBackDataWithDataDic:(NSDictionary *)dataDic withEmail:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField withSignupError:(UILabel *)signupErrorLabel withPasswdRequirement:(UITextView *)passwdRequirementTextView;


@end
