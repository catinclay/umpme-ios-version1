//
//  UMPLibSyncToLocalDB.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibSyncToLocalDB.h"
#import "UMPLibApiManager.h"

@implementation UMPLibSyncToLocalDB

+ (id)shareSyncToLocalDBManager {
    static UMPLibSyncToLocalDB *umpSyncToLocalDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpSyncToLocalDB = [[UMPLibSyncToLocalDB alloc] init];
    });
    return umpSyncToLocalDB;
}

- (BOOL)syncToLocalDB_InsertDataToAutoLoginTableWithDataDic:(NSDictionary *)dataDic {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    if (dataDic != nil) {
        NSString *uid = [dataDic objectForKey:@"uid"];
        NSString *ulogin_token = [dataDic objectForKey:@"ulogin_token"];
        NSString *token_update_date = [dataDic objectForKey:@"token_update_date"];
        NSString *token_update_time = [dataDic objectForKey:@"token_update_time"];
        NSString *allow_autologin = [dataDic objectForKey:@"allow_autologin"];
        
        NSString *sqlSentence = [[NSString alloc]
                                 initWithFormat:@"INSERT INTO autologin (uid, autologin_token, token_update_date, token_update_time, allow_autologin, is_sync) VALUES (%@, '%@', '%@', '%@', %@, 1)",
                                 uid,
                                 ulogin_token,
                                 token_update_date,
                                 token_update_time,
                                 allow_autologin];
        
        if([umpApiManager.umpLocalDB openLocalDB] &&
           [umpApiManager.umpLocalDB insertDataOnLocalDB:sqlSentence] &&
           [umpApiManager.umpLocalDB closeLocalDB]) {
            
            return YES;
        } else {
            
            if (UMPME_DEBUG) NSLog(@"[Debug][Error][UMPAPI][SyncToLocalDB][InsertDataToAutoLoginTable]Can not insert data into local db.");
            return NO;
        }
        
    } else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error][UMPAPI][SyncToLocalDB][InsertDataToAutoLoginTable]Can not download data from server.");
        return NO;
    }
}



@end
