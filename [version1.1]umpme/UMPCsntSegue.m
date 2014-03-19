//
//  UMPCsntSegue.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCsntSegue.h"

@implementation UMPCsntSegue

+ (id)shareCsntSegueManager {
    static UMPCsntSegue *umpCsntSegue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCsntSegue = [[UMPCsntSegue alloc] init];
    });
    return umpCsntSegue;
}

- (id)init {
    if (self = [super init]) {
        self.autoLoginToLogin = @"segue_autologinvc_to_loginvc";
        self.autoLoginToMainTBC = @"segue_autologinvc_to_maintbc";
        self.signupToLoginGenerally = @"segue_signupvc_to_loginvc_general";
        self.signupToLoginSuccessfully = @"segue_signupvc_to_loginvc_successful";
        self.loginToSignup = @"segue_loginvc_to_signupvc";
        self.loginToMainTBC = @"segue_loginvc_to_maintbc";
        self.personalPageToLogin = @"segue_personalpagevc_to_loginvc";
    }
    return self;
}

@end
