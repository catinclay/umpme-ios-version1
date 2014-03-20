//
//  UMPBhvLogin.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPBhvLogin.h"

@implementation UMPBhvLogin

+ (id)shareBhvLoginManager {
    static UMPBhvLogin *umpBhvLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpBhvLogin = [[UMPBhvLogin alloc] init];
    });
    return umpBhvLogin;
}

- (void)initStateForLoginErrorLabel:(UILabel *)loginErrorLabel {
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    loginErrorLabel.text = @"";
    loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpBlackColor;
}

- (BOOL)checkInputForEmail:(UITextField *)uemailTextField andPasswd:(UITextField *)upasswdTextField withLoginErrorLable:(UILabel *)loginErrorLabel {
    
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uemail = [[uemailTextField.text
                         stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    
    NSString *upasswd = [upasswdTextField.text
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([uemail length] == 0 || [upasswd length] == 0) {
        loginErrorLabel.text = @"email or passwd can not be empty";
        loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
        return NO;
        
    } else if (![umpApiManager.umpRegex isEmailAddress:uemail]) {
        loginErrorLabel.text = @"email address is illegal";
        loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
        return NO;
        
    } else if (![umpApiManager.umpRegex isPassword:upasswd]) {
        loginErrorLabel.text = @"password is illegal";
        loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
        return NO;
    }
    return YES;
}

- (NSDictionary *)dealWithInputWithEmail:(UITextField *)uemailTextField andPasswd:(UITextField *)upasswdTextField {

    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *std_uemail = [[uemailTextField.text
                         stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    
    NSString *raw_upasswd = [upasswdTextField.text
                         stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *md5_upasswd = [umpApiManager.umpMD5 convertStringToMD5:raw_upasswd];
    
    NSMutableDictionary *dataMutableDic = [[NSMutableDictionary alloc] init];
    [dataMutableDic setObject:std_uemail forKey:@"uemail"];
    [dataMutableDic setObject:md5_upasswd forKey:@"upasswd"];
    
    NSDictionary *dataDic = [[NSDictionary alloc] initWithDictionary:dataMutableDic];
    return dataDic;
}

- (NSDictionary *)talkToServerWithDataDic:(NSDictionary *)dataDic {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *message = [[NSString alloc]
                         initWithFormat:@"?uemail=%@&upasswd=%@",
                         [dataDic objectForKey:@"uemail"],
                         [dataDic objectForKey:@"upasswd"]];
    
    NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                    generateGETRequestForService:@"login" withMessage:message];
    
    NSDictionary *backData = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    return backData;
}

- (NSDictionary *)analyzeBackDataDic:(NSDictionary *)backDataDic withEmailTextField:(UITextField *)uemailTextField andPasswdTextField:(UITextField *)upasswdTextField withLoginErrorLable:(UILabel *)loginErrorLabel {
    
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    NSData *backData = [backDataDic objectForKey:@"backData"];
    NSError *jsonError = nil;
    NSDictionary *jsonDic = [NSJSONSerialization
                             JSONObjectWithData:backData
                             options:NSJSONReadingAllowFragments
                             error:&jsonError];
    
    NSDictionary *analyzeBackDataDic = nil;
    if (jsonError == nil) {
        NSString *re_succ = [jsonDic objectForKey:@"login_succ"];
        NSString *re_errorcode = [jsonDic objectForKey:@"error_code"];
        NSString *re_uid = [jsonDic objectForKey:@"uid"];
        
        if ([re_succ isEqualToString:@"no"]) { // login unsuccessfully.
            if ([re_errorcode isEqualToString:@"passwdwrong"]) {
                loginErrorLabel.text = @"password is wrong";
                loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                upasswdTextField.text = @"";
                
            } else if ([re_errorcode isEqualToString:@"noemail"]) {
                loginErrorLabel.text = @"email is wrong";
                loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                uemailTextField.text = @"";
                
            } else {
                loginErrorLabel.text = @"please try again";
                loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
                
            }
            
        } else { // login succesfully.
            NSMutableDictionary *analyzeBackDataMutableDic = [[NSMutableDictionary alloc] init];
            [analyzeBackDataMutableDic setObject:re_uid forKey:@"uid"];
            analyzeBackDataDic = [[NSDictionary alloc] initWithDictionary:analyzeBackDataMutableDic];
        }
        
    } else {
        loginErrorLabel.text = @"please try again";
        loginErrorLabel.textColor = umpCsntManager.umpCsntColorManager.umpRedColor;
    }
    
    return analyzeBackDataDic;
}


- (BOOL)updateLocalAutologinFlagForUid:(NSString *)uid basedOnSwitch:(UISwitch *)autoLoginSwitch {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    BOOL autoLoginSwitchState = [autoLoginSwitch isOn];
    
    NSString *autoLoginSwitchStateString;
    if (autoLoginSwitchState) {
        // allow auto login
        autoLoginSwitchStateString = @"1";
    } else {
        // not allow auto login
        autoLoginSwitchStateString = @"0";
    }
    
    NSMutableDictionary *inputDataMutableDic = [[NSMutableDictionary alloc] init];
    [inputDataMutableDic setObject:uid forKey:@"uid"];
    [inputDataMutableDic setObject:autoLoginSwitchStateString forKey:@"allow_autologin"];
    NSDictionary *inputDataDic = [[NSDictionary alloc] initWithDictionary:inputDataMutableDic];
    
    return [umpApiManager.umpSyncToLocalDB
            syncToLocalDB_updateAutoLoginFlagToAutoLoginTableWithDataDic:inputDataDic];
    
}

- (BOOL)updateServerAutoLoginFlagForUid:(NSString *)uid basedOnSwitch:(UISwitch *)autoLoginSwitch {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    BOOL autoLoginSwitchState = [autoLoginSwitch isOn];
    
    NSString *autoLoginSwitchStateString;
    if (autoLoginSwitchState) {
        // allow auto login
        autoLoginSwitchStateString = @"1";
    } else {
        // not allow auto login
        autoLoginSwitchStateString = @"0";
    }
    NSMutableDictionary *inputDataMutableDic = [[NSMutableDictionary alloc] init];
    [inputDataMutableDic setObject:uid forKey:@"uid"];
    [inputDataMutableDic setObject:autoLoginSwitchStateString forKey:@"allow_autologin"];
    NSDictionary *inputDataDic = [[NSDictionary alloc] initWithDictionary:inputDataMutableDic];
    
    return [umpApiManager.umpSyncToServerDB
            syncToServerDB_updateAutoLoginFlagToAutoLoginTableWithDataDic:inputDataDic];
}



@end





















