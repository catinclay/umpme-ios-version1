//
//  UMPCsntLocalDB.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCsntLocalDB.h"

@implementation UMPCsntLocalDB


+ (id)shareCsntLocalDBManager {
    static UMPCsntLocalDB *umpCsntLocalDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCsntLocalDB = [[UMPCsntLocalDB alloc] init];
    });
    return umpCsntLocalDB;
}

- (id)init {
    if (self = [super init]) {
        self.localDBName = @"ump_local_db.sqlite";
    }
    return self;
}

@end
