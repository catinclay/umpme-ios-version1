//
//  UMPCacheManager.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCacheManager.h"

@implementation UMPCacheManager

+ (id)shareCacheManager {
    static UMPCacheManager *umpCacheManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCacheManager = [[UMPCacheManager alloc] init];
    });
    return umpCacheManager;
}

- (id)init {
    if (self = [super init]) {
        self.umpCurrUser = [UMPCurrUser shareCurrUserManager];
    }
    return self;
}

@end
