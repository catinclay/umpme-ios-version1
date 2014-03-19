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

@end
