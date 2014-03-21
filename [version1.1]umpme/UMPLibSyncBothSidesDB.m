//
//  UMPLibSyncBothSidesDB.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibSyncBothSidesDB.h"
#import "UMPLibApiManager.h"


@implementation UMPLibSyncBothSidesDB

+ (id)shareSyncBothSidesDBManager {
    static UMPLibSyncBothSidesDB *umpSyncBothSidesDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpSyncBothSidesDB = [[UMPLibSyncBothSidesDB alloc] init];
    });
    return umpSyncBothSidesDB;
}



@end
