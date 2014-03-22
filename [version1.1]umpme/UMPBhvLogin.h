//
//  UMPBhvLogin.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPCsntManager.h"
#import "UMPLibApiManager.h"


@interface UMPBhvLogin : NSObject


+ (id)shareBhvLoginManager;

- (void)initStateForLoginErrorLabel:(UILabel *)loginErrorLabel;

- (BOOL)checkInputForEmail:(UITextField *)uemailTextField andPasswd:(UITextField *)upasswdTextField withLoginErrorLable:(UILabel *)loginErrorLabel;

- (NSDictionary *)dealWithInputWithEmail:(UITextField *)uemailTextField andPasswd:(UITextField *)upasswdTextField;

- (NSDictionary *)talkToServerWithDataDic:(NSDictionary *)dataDic;

- (NSDictionary *)analyzeBackDataDic:(NSDictionary *)backDataDic withEmailTextField:(UITextField *)uemailTextField andPasswdTextField:(UITextField *)upasswdTextField withLoginErrorLable:(UILabel *)loginErrorLabel;

- (BOOL)dealWithRecoverFromCrash;

- (BOOL)updateServerAutoLoginFlagForUid:(NSString *)uid basedOnSwitch:(UISwitch *)autoLoginSwitch;
- (BOOL)writeAutoLoginInfoIntoLocalDBForUid:(NSString *)uid;
- (BOOL)writeIntMsgDataIntoLocalIntMsgTableForUid:(NSString *)uid;

- (BOOL)connectIntMsgServerForUid:(NSString *)uid;

@end
