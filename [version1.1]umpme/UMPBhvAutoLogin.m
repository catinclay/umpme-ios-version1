//
//  UMPBhvAutoLogin.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/21/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPBhvAutoLogin.h"

@implementation UMPBhvAutoLogin

+ (id)shareBhvAutoLoginManager {
    static UMPBhvAutoLogin *umpAutoLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpAutoLogin = [[UMPBhvAutoLogin alloc] init];
    });
    return umpAutoLogin;
}

@end
