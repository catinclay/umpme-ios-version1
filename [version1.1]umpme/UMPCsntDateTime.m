//
//  UMPCsntDateTime.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCsntDateTime.h"

@implementation UMPCsntDateTime


+ (id)shareCsntDateTimeManager {
    static UMPCsntDateTime *umpCsntDateTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCsntDateTime = [[UMPCsntDateTime alloc] init];
    });
    return umpCsntDateTime;
}

- (id)init {
    if (self = [super init]) {
         self.umpTimeZone = @"America/Chicago";
    }
    return self;
}

@end
