//
//  UMPBhvManager.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPBhvManager.h"

@implementation UMPBhvManager

+ (id)shareBhvManager {
    static UMPBhvManager *umpBhvManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpBhvManager = [[UMPBhvManager alloc] init];
    });
    return umpBhvManager;
}

- (id)init {
    if (self = [super init]) {
        // Signup
        self.umpBhvSignup = [UMPBhvSignup shareSignupManager];
    }
    return self;
}

@end
