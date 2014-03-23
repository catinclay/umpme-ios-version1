//
//  UMPCsntManager.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCsntManager.h"

@implementation UMPCsntManager

+ (id)shareCsntManager {
    static UMPCsntManager *umpCsntManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCsntManager = [[UMPCsntManager alloc] init];
    });
    return umpCsntManager;
}

- (id)init {
    if (self = [super init]) {
        self.umpCsntNetworkManager = [UMPCsntNetwork shareCsntNetworkManager];
        self.umpCsntLocalDBManager = [UMPCsntLocalDB shareCsntLocalDBManager];
        self.umpCsntDateTimeManager = [UMPCsntDateTime shareCsntDateTimeManager];
        self.umpCsntColorManager = [UMPCsntColor shareCsntColorManager];
        self.umpCsntSegueManager = [UMPCsntSegue shareCsntSegueManager];
        self.umpCsntImageManager = [UMPCsntImage shareCnstImageManager];
    }
    return self;
}

@end
