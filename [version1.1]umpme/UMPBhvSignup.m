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

- (BOOL)userSignupWithEmail:(UITextField *)uemailTextField withConfirmEmail:(UITextField *)uconfirmEmailTextField withPasswd:(UITextField *)upasswdTextField withConfirmPasswd:(UITextField *)uconfirmPasswdTextField withSignupError:(UILabel *)signupErrorLabel withPasswdRequirement:(UITextView *)passwdRequirementTextView {
    
    __block BOOL signupSucc = NO;
    
    // Get umpme api manager.
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    // Get umpme constant manager.
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    
    // Clear signupErrorLabel text.
    signupErrorLabel.text = @"";
    
    // Clear passwdRequirementTextView text color.
    passwdRequirementTextView.textColor = [UIColor grayColor];
    
    // Get the email, re-email, passwd, and re-passwd.
    NSString *uemail = [uemailTextField.text
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *re_email = [uconfirmEmailTextField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *upasswd = [upasswdTextField.text
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *re_passwd = [uconfirmPasswdTextField.text
                           stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Check input validation.
    if ([uemail length] == 0 || [re_email length] == 0 ||
        [upasswd length] == 0 || [re_passwd length] == 0) {
        
        signupErrorLabel.text = @"the fields can not be empty.";
        
    } else if (![umpApiManager.umpRegex isEmailAddress:uemail]) { // Check validation of email address.
        signupErrorLabel.text = @"email address is not legal.";
        NSLog(@"uemal = %@", uemail);
        
    } else if (![uemail isEqualToString:re_email]) { // Check the re_email == uemail.
        signupErrorLabel.text = @"two emails are not same.";
        
    } else if (![umpApiManager.umpRegex isPassword:upasswd]) { // Check validation of password.
        // Clear passwd and repasswd text fields.
        upasswdTextField.text = @"";
        uconfirmPasswdTextField.text = @"";
        
        // Guide user set right password.
        // Set password requirement text color to red.
        passwdRequirementTextView.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
        
    } else if (! [upasswd isEqualToString:re_passwd]) { // Check the re_passwd == upasswd.
        signupErrorLabel.text = @"two passwd are not same";
        
    } else { // Upload the user's signup info to server.
        
        // Standardizate user signup email.
        NSString *std_uemail = [uemail lowercaseString];
        // MD5 user password.
        NSString *md5_upasswd = [umpApiManager.umpMD5 convertStringToMD5:upasswd];
        
        
        // Build the whole request string.
        NSString *getRequestMessage = [[NSString alloc]
                                       initWithFormat:@"?uemail=%@&upasswd=%@", std_uemail, md5_upasswd];
        
        
        // Upload the request to server.
        NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                        generateGETRequestForDeviceCategory:@"mobile"
                                        forDevice:@"ios"
                                        forService:@"signup"
                                        withMessage:getRequestMessage];
        

        __block BOOL connectionDone = NO;
        NSCondition *condition = [NSCondition new];
        [condition lock];
        
        NSOperationQueue *connectionQueue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:connectionQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if ([data length] > 0 && connectionError == nil) { // Get response from server.
                // Check the response from server.
                NSMutableDictionary *jsonDic = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                error:nil];
                
                NSString *response_message_signup_succ = [[NSString alloc]
                                                          initWithFormat:@"%@",
                                                          [jsonDic objectForKey:@"signup_succ"]];
                
                NSString *response_message_error_code = [[NSString alloc]
                                                         initWithFormat:@"%@",
                                                         [jsonDic objectForKey:@"error_code"]];
                /*
                // This message is for debug.
                NSString *response_message_add_message = [[NSString alloc]
                                                          initWithFormat:@"%@",
                                                          [jsonDic objectForKey:@"add_message"]];
                 */
                
                
                NSString *response_message_ulogin_token_md5 = [[NSString alloc]
                                                               initWithFormat:@"%@",
                                                               [jsonDic objectForKey:@"ulogin_token_md5"]];
                
                NSString *response_message_uid = [[NSString alloc]
                                                  initWithFormat:@"%@", [jsonDic objectForKey:@"uid"]];
                
                NSString *response_message_token_update_date = [[NSString alloc]
                                                                initWithFormat:@"%@",
                                                                [jsonDic objectForKey:@"token_update_date"]];
                
                NSString *response_message_token_update_time = [[NSString alloc]
                                                                initWithFormat:@"%@",
                                                                [jsonDic objectForKey:@"token_update_time"]];
                
                
                if ([response_message_signup_succ isEqualToString:@"no"]) { // Is not successful.
                    
                    if ([response_message_error_code isEqualToString:@"emailerror"]) {
                        // Guide user to try to the other email address to sign up umpme.
                        // Go to 'Main TBC'.
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            signupErrorLabel.text = @"this email has been used";
                            signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                            uemailTextField.text = @"";
                            uconfirmEmailTextField.text = @"";
                            upasswdTextField.text = @"";
                            uconfirmPasswdTextField.text = @"";
                            passwdRequirementTextView.textColor = [UIColor grayColor];
                            
                        });
                        
                        
                    } else if ([response_message_error_code isEqualToString:@"iossideerror"]) {
                        // Guide user to try re-input everything again.
                        // Go to 'Main TBC'.
                        dispatch_async(dispatch_get_main_queue(), ^{
                            signupErrorLabel.text = @"please input your information again";
                            signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                            uemailTextField.text = @"";
                            uconfirmEmailTextField.text = @"";
                            upasswdTextField.text = @"";
                            uconfirmPasswdTextField.text = @"";
                            passwdRequirementTextView.textColor = [UIColor grayColor];
                        });
                        
                        
                    } else {
                        // Guide user to wait for a while.
                        
                        // Go to 'Main TBC'.
                        dispatch_async(dispatch_get_main_queue(), ^{
                            signupErrorLabel.text = @"web error, please try again later";
                            signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                        });
                    }
                    
                } else { // Successful.
                    // Write ulogin_token_md5 and auto login flag into the local db.
                    NSString *insertAutoLoginRecordSQL = [[NSString alloc]
                                                         initWithFormat:
                                                         @"INSERT INTO autologin (uid, autologin_token, token_update_date, token_update_time, allow_autologin, is_sync) VALUES (%@, '%@', '%@', '%@', 0, 1)",
                                                         response_message_uid,
                                                         response_message_ulogin_token_md5,
                                                         response_message_token_update_date,
                                                         response_message_token_update_time];
                    
                    if ([umpApiManager.umpLocalDB openLocalDB] &&
                        [umpApiManager.umpLocalDB insertDataOnLocalDB:insertAutoLoginRecordSQL] &&
                        [umpApiManager.umpLocalDB closeLocalDB]) {
                        
                        signupSucc = YES;
                        
                        NSLog(@"[debug][temp][check here] >> signup inside << = yes");
                    }
                }
                
            } else if ([data length] == 0 && connectionError == nil) { // Can not get response from server.
                // Guide user to sign up again.
                // Go to 'Main TBC'.
                dispatch_async(dispatch_get_main_queue(), ^{
                    signupErrorLabel.text = @"Please try again.";
                    signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                });
                
            } else if(connectionError != nil) { // Connection error.
                // Inform user that "Can not connect the Internet."
                // Go to 'Main TBC'.
                dispatch_async(dispatch_get_main_queue(), ^{
                    signupErrorLabel.text = @"Cannot connect Internet.";
                    signupErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                });
            }
            [condition lock];
            connectionDone = YES;
            [condition signal];
            [condition unlock];
            
        }];
        
        while (!connectionDone) {
            [condition wait];
        }
        [condition unlock];
        
    }
    
    return signupSucc;
}

@end
