//
//  UMPCurrUser.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCurrUser.h"

@implementation UMPCurrUser

+ (id)shareCurrUserManager {
    static UMPCurrUser *umpCurrUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCurrUser = [[UMPCurrUser alloc] init];
    });
    return umpCurrUser;
}

- (id)init {
    if (self = [super init]) {
        self.currUid = nil;
        self.friendsIdsArray = nil;
    }
    return self;
}

@end
