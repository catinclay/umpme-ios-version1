//
//  UMPLibExtractDataFromLocalDB.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibExtractDataFromLocalDB.h"
#import "UMPLibApiManager.h"

@implementation UMPLibExtractDataFromLocalDB

+ (id)shareExtractDataFromLocalDBManager {
    static UMPLibExtractDataFromLocalDB *umpExtractDataFromLocalDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpExtractDataFromLocalDB = [[UMPLibExtractDataFromLocalDB alloc] init];
    });
    return umpExtractDataFromLocalDB;
}

- (NSMutableArray *)extractDataFromAutoLogin{
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *querySQL = [[NSString alloc] initWithFormat:@"SELECT * FROM autologin"];
    
    [umpApiManager.umpLocalDB openLocalDB];
    NSMutableArray *backDataArray = [umpApiManager.umpLocalDB querySingleRowDataOnLocalDB:querySQL];
    [umpApiManager.umpLocalDB closeLocalDB];
    
    return backDataArray;
}

- (NSString *)getCurrUserUid {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    // Extract uid from the local db "login" table.
    NSString *querySQL = @"SELECT * FROM login";
    [umpApiManager.umpLocalDB openLocalDB];
    NSMutableArray *rest = [umpApiManager.umpLocalDB querySingleRowDataOnLocalDB:querySQL];
    [umpApiManager.umpLocalDB closeLocalDB];
    if (rest == nil) {
        return nil;
    } else {
        return [rest objectAtIndex:0];
    }
}

- (NSString *)getCurrLoginServerId {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    // Extract uid from the local db "login" table.
    NSString *querySQL = @"SELECT * FROM login";
    [umpApiManager.umpLocalDB openLocalDB];
    NSMutableArray *rest = [umpApiManager.umpLocalDB querySingleRowDataOnLocalDB:querySQL];
    [umpApiManager.umpLocalDB closeLocalDB];
    if (rest == nil) {
        return nil;
    } else {
        return [rest objectAtIndex:1];
    }
}

@end
