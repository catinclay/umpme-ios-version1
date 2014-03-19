//
//  UMPLibApiManager.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibApiManager.h"

@implementation UMPLibApiManager

+ (id)shareApiManager {
    static UMPLibApiManager *umpApiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpApiManager = [[UMPLibApiManager alloc] init];
    });
    return umpApiManager;
}

- (id)init {
    if (self = [super init]) {
        // Regex.
        self.umpRegex = [UMPLibRegex shareRegexManager];
        
        // DB.
        self.umpLocalDB = [UMPLibLocalDB shareLocalDBManager];
        
        // MD5.
        self.umpMD5 = [UMPLibMD5 shareMD5Manager];
        
        // Network.
        self.umpNetwork = [UMPLibNetwork shareNetWorkManager];
        
        // DateTime.
        self.umpDateTime = [UMPLibDateTime shareDateTimeManager];
        
        // Download Data.
        self.umpDownloadData = [UMPLibDownloadData shareDownloadDataManager];
        
        // Sync to local DB.
        self.umpSyncToLocalDB = [UMPLibSyncToLocalDB shareSyncToLocalDBManager];
    }
    return self;
}


@end
