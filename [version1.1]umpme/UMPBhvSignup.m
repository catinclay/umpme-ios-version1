//
//  UMPBhvSignup.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPBhvSignup.h"

@implementation UMPBhvSignup

+ (id)shareSignupManager {
    static UMPBhvSignup *umpBhvSignup = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpBhvSignup = [[UMPBhvSignup alloc] init];
    });
    return umpBhvSignup;
}


- (void)initStateForErrorLabel:(UILabel *)signupErrorLabel andPasswdRequirementTextView:(UITextView *)passwdRequirementTextView {
    
    // Clear signupErrorLabel text.
    signupErrorLabel.text = @"";
    // Clear passwdRequirementTextView text color.
    passwdRequirementTextView.textColor = [UIColor grayColor];
    
}

- (NSDictionary *)dealWithInput:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField {
    
    // Get the email, re-email, passwd, and re-passwd.
    NSString *uemail = [[uemailTextField.text
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    NSString *re_email = [[uconfirmEmailTextField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    NSString *upasswd = [upasswdTextField.text
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *re_passwd = [uconfirmPasswdTextField.text
                           stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableDictionary *dataMutableDic = [[NSMutableDictionary alloc] init];
    [dataMutableDic setObject:uemail forKey:@"uemail"];
    [dataMutableDic setObject:re_email forKey:@"re_email"];
    [dataMutableDic setObject:upasswd forKey:@"upasswd"];
    [dataMutableDic setObject:re_passwd forKey:@"re_passwd"];
    
    NSDictionary *dataDic = [[NSDictionary alloc] initWithDictionary:dataMutableDic];
    return dataDic;
}

- (BOOL)checkInputForDataDic:(NSDictionary *)dataDic withEmail:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField withSignupError:(UILabel *)signupErrorLabel withPasswdRequirement:(UITextView *)passwdRequirementTextView {
    
    NSString *uemail = [dataDic objectForKey:@"uemail"];
    NSString *re_email = [dataDic objectForKey:@"re_email"];
    NSString *upasswd = [dataDic objectForKey:@"upasswd"];
    NSString *re_passwd = [dataDic objectForKey:@"re_passwd"];
    
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    BOOL is_legal = NO;
    
    // Check input validation.
    if ([uemail length] == 0 || [re_email length] == 0 ||
        [upasswd length] == 0 || [re_passwd length] == 0) {
        
        signupErrorLabel.text = @"the fields can not be empty.";
        
    } else if (![umpApiManager.umpRegex isEmailAddress:uemail]) {
        
        signupErrorLabel.text = @"email address is not legal.";
        
    } else if (![uemail isEqualToString:re_email]) {
        signupErrorLabel.text = @"two emails are not same.";
        
    } else if (![umpApiManager.umpRegex isPassword:upasswd]) {
        // Clear passwd and repasswd text fields.
        upasswdTextField.text = @"";
        uconfirmPasswdTextField.text = @"";
        
        // Guide user set right password.
        // Set password requirement text color to red.
        passwdRequirementTextView.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
        
    } else if (! [upasswd isEqualToString:re_passwd]) {
        signupErrorLabel.text = @"two passwd are not same";
        
    } else {
        is_legal = YES;
    }
    
    return is_legal;
    
}

-(NSDictionary *)encodeInputForDataDic:(NSDictionary *)dataDic {
    
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uemail = [dataDic objectForKey:@"uemail"];
    NSString *raw_upasswd = [dataDic objectForKey:@"upasswd"];
    
    NSString *md5_upasswd = [umpApiManager.umpMD5 convertStringToMD5:raw_upasswd];
    
    NSMutableDictionary *backDataMutableDic = [[NSMutableDictionary alloc] init];
    [backDataMutableDic setObject:uemail forKey:@"uemail"];
    [backDataMutableDic setObject:md5_upasswd forKey:@"md5_upasswd"];
    NSDictionary *backDataDic = [[NSDictionary alloc] initWithDictionary:backDataMutableDic];
    
    return backDataDic;
}


- (NSDictionary *)talkToServerWithDataDic:(NSDictionary *)dataDic {
    
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *std_uemail = [dataDic objectForKey:@"uemail"];
    NSString *md5_upasswd = [dataDic objectForKey:@"md5_upasswd"];
    
    // Build the whole request string.
    NSString *requestMessage = [[NSString alloc]
                                initWithFormat:@"?uemail=%@&upasswd=%@", std_uemail, md5_upasswd];
    // Upload the request to server.
    NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                    generateGETRequestForService:@"signup"
                                    withMessage:requestMessage];
    
    NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    
    return backDataDic;
}


- (NSDictionary *)analyzeServerBackDataWithDataDic:(NSDictionary *)dataDic withEmail:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField withSignupError:(UILabel *)signupErrorLabel withPasswdRequirement:(UITextView *)passwdRequirementTextView {
    
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    NSDictionary *backDataDic = nil;
    
    NSData *connectionBackData = [dataDic objectForKey:@"backData"];
    
    if ([connectionBackData length] > 0) {
        // Check the response from server.
        NSMutableDictionary *jsonDic = [NSJSONSerialization
                                        JSONObjectWithData:connectionBackData
                                        options:NSJSONReadingAllowFragments
                                        error:nil];
        
        NSString *response_message_signup_succ = [[NSString alloc]
                                                  initWithFormat:@"%@",
                                                  [jsonDic objectForKey:@"signup_succ"]];
        
        NSString *response_message_error_code = [[NSString alloc]
                                                 initWithFormat:@"%@",
                                                 [jsonDic objectForKey:@"error_code"]];
        
        // This message is for debug.
        NSString *response_message_add_message = [[NSString alloc]
        initWithFormat:@"%@", [jsonDic objectForKey:@"add_message"]];
        if (UMPME_DEBUG) NSLog(@"[debug][error][sign up bhv][analyze back data]add error msg = %@", response_message_add_message);
         
        
        NSString *response_message_uid = [[NSString alloc]
                                          initWithFormat:@"%@", [jsonDic objectForKey:@"uid"]];
        
        
        if ([response_message_signup_succ isEqualToString:@"no"]) { // Is not successful.
            
            if ([response_message_error_code isEqualToString:@"emailerror"]) {
                // Guide user to try to the other email address to sign up umpme.
                signupErrorLabel.text = @"this email has been used";
                signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                uemailTextField.text = @"";
                uconfirmEmailTextField.text = @"";
                upasswdTextField.text = @"";
                uconfirmPasswdTextField.text = @"";
                passwdRequirementTextView.textColor = [UIColor grayColor];
                
                
            } else if ([response_message_error_code isEqualToString:@"iossideerror"]) {
                // Guide user to try re-input everything again.
                signupErrorLabel.text = @"please input your information again";
                signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                uemailTextField.text = @"";
                uconfirmEmailTextField.text = @"";
                upasswdTextField.text = @"";
                uconfirmPasswdTextField.text = @"";
                passwdRequirementTextView.textColor = [UIColor grayColor];
                
                
            } else {
                // Guide user to wait for a while.
                signupErrorLabel.text = @"web error, please try again later";
                signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
            }
            
        } else { // Successful.
            
            NSMutableDictionary *backDataMutableDic = [[NSMutableDictionary alloc] init];
            [backDataMutableDic setObject:response_message_uid forKey:@"uid"];
            backDataDic = [[NSDictionary alloc] initWithDictionary:backDataMutableDic];

        }
        
    } else if ([connectionBackData length] == 0) { // Can not get response from server.
        // Guide user to sign up again.
        // Go to 'Main TBC'.
        signupErrorLabel.text = @"Please try again.";
        signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
        
    }
    
    return backDataDic;
}

















@end
