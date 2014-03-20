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

- (NSMutableArray *)extractDataFromAutoLoginWithUid:(NSString *)uid {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *querySQL = [[NSString alloc] initWithFormat:@"SELECT * FROM autologin WHERE uid = %@", uid];
    
    return [umpApiManager.umpLocalDB querySingleRowDataOnLocalDB:querySQL];
}


@end
