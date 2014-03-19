//
//  UMPCsntSegue.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMPCsntSegue : NSObject

@property (strong, nonatomic) NSString *autoLoginToLogin;
@property (strong, nonatomic) NSString *autoLoginToMainTBC;
@property (strong, nonatomic) NSString *signupToLoginGenerally;
@property (strong, nonatomic) NSString *signupToLoginSuccessfully;
@property (strong, nonatomic) NSString *loginToSignup;
@property (strong, nonatomic) NSString *loginToMainTBC;
@property (strong, nonatomic) NSString *personalPageToLogin;

+ (id)shareCsntSegueManager;

@end
