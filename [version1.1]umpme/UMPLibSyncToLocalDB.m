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
        NSString *is_sync = [dataDic objectForKey:@"is_sync"];
        
        NSString *sqlSentence = [[NSString alloc]
                                 initWithFormat:@"INSERT INTO autologin (uid, autologin_token, token_update_date, token_update_time, allow_autologin, is_sync) VALUES (%@, '%@', '%@', '%@', %@, %@)",
                                 uid,
                                 ulogin_token,
                                 token_update_date,
                                 token_update_time,
                                 allow_autologin,
                                 is_sync];
        
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

- (BOOL)syncToLocalDB_InsertDataToAutoLoginTableWithSQL:(NSString *)sqlSentence {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    if ([umpApiManager.umpLocalDB openLocalDB] &&
        [umpApiManager.umpLocalDB insertDataOnLocalDB:sqlSentence] &&
        [umpApiManager.umpLocalDB closeLocalDB]) {
        
        return YES;
        
    } else {
        return NO;
    }
}

- (BOOL)syncToLocalDB_updateAutoLoginFlagToAutoLoginTableWithDataDic:(NSDictionary *)dataDic {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = [dataDic objectForKey:@"uid"];
    NSString *autoLoginSwitchStateString = [dataDic objectForKey:@"allow_autologin"];
    
    NSString *updateSQL = [[NSString alloc]
                           initWithFormat:@"UPDATE autologin SET allow_autologin=%@ WHERE uid=%@",
                           autoLoginSwitchStateString, uid];
    [umpApiManager.umpLocalDB openLocalDB];
    BOOL updateBoolFlag = [umpApiManager.umpLocalDB updateDataOnLocalDB:updateSQL];
    [umpApiManager.umpLocalDB closeLocalDB];
    return updateBoolFlag;
}

- (BOOL)syncToLocalDB_updateAutoLoginAllDataToAutoLoginTableWithDataDic:(NSDictionary *)dataDic {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = [dataDic objectForKey:@"uid"];
    NSString *ulogin_token = [dataDic objectForKey:@"ulogin_token"];
    NSString *token_update_date = [dataDic objectForKey:@"token_update_date"];
    NSString *token_update_time = [dataDic objectForKey:@"token_update_time"];
    NSString *allow_autologin = [dataDic objectForKey:@"allow_autologin"];
    NSString *is_sync = [dataDic objectForKey:@"is_sync"];
    
    NSString *updateSQL = [[NSString alloc]
                           initWithFormat:@"UPDATE autologin SET autologin_token='%@', token_update_date='%@', token_update_time='%@', allow_autologin=%@, is_sync=%@ WHERE uid=%@",
                           ulogin_token,
                           token_update_date,
                           token_update_time,
                           allow_autologin,
                           is_sync,
                           uid];

    if ([umpApiManager.umpLocalDB openLocalDB] &&
        [umpApiManager.umpLocalDB updateDataOnLocalDB:updateSQL] &&
        [umpApiManager.umpLocalDB closeLocalDB]) return YES;
    
    return NO;
}
/////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)syncTolocalDB_InsertDataToLoginTableWithDataDic:(NSDictionary *)dataDic {
//    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
//    
//    NSLog(@"[debug][error][sync local db][###insert into local login table]##------## hrere 1");
//    
//    
//    NSString *uid = [dataDic objectForKey:@"uid"];
//    NSString *login_server_id = [dataDic objectForKey:@"login_server_id"];
//    
//    NSString *insertSQL = [[NSString alloc]
//                           initWithFormat:@"INSERT INTO login (uid, login_id) VALUES (%@, %@)",
//                           uid, login_server_id];
//    
//    NSLog(@"[debug][error][sync local db][###insert into local login table]uid = %@, login_id = %@", uid, login_server_id);
//    
//    if ([umpApiManager.umpLocalDB openLocalDB] &&
//        [umpApiManager.umpLocalDB insertDataOnLocalDB:insertSQL] &&
//        [umpApiManager.umpLocalDB closeLocalDB]) return YES;
    
    return NO;
}
/////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)syncToLocalDB_InsertDataToIntMsgReceiveTableForUid:(NSString *)uid withDataArray:(NSArray *)dataArray {
    
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    if (dataArray != nil) {
        NSInteger dataNum = [dataArray count];
        
        // NSLog(@"[debug][error][sync to local db][insert msg to local db] data num = %ld", (long)dataNum);
        
        [umpApiManager.umpLocalDB openLocalDB];
        for (NSInteger i = 0; i < dataNum; i ++) {
            NSDictionary *dataDic = [dataArray objectAtIndex:i];
            
            NSString *intmsg_server_id = [dataDic objectForKey:@"intmsg_server_id"];
            NSString *to_friend_uid = [dataDic objectForKey:@"to_friend_uid"];
            NSString *intmsg = [dataDic objectForKey:@"intmsg"];
            NSString *is_read = [dataDic objectForKey:@"is_read"];
            NSString *send_date = [dataDic objectForKey:@"send_date"];
            NSString *send_time = [dataDic objectForKey:@"send_time"];
            
            NSString *insertSQL = [[NSString alloc]
                                   initWithFormat:@"INSERT INTO intmsg_receive (intmsg_server_id, from_friend_uid, intmsg, is_read, friend_send_data, friend_send_time) VALUES (%@, %@, '%@', %@, '%@', '%@')",
                                   intmsg_server_id,
                                   to_friend_uid,
                                   intmsg, is_read,
                                   send_date,
                                   send_time];
            
            [umpApiManager.umpLocalDB insertDataOnLocalDB:insertSQL];
            
        }
        [umpApiManager.umpLocalDB closeLocalDB];
        return YES;
        
    } else {
        return NO;
    }
}

@end














