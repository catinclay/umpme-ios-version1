//
//  UMPBhvAutoLogin.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/21/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPBhvAutoLogin.h"
#import "UMPLibApiManager.h"


@implementation UMPBhvAutoLogin

+ (id)shareBhvAutoLoginManager {
    static UMPBhvAutoLogin *umpAutoLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpAutoLogin = [[UMPBhvAutoLogin alloc] init];
    });
    return umpAutoLogin;
}


- (NSDictionary *)checkLocalAutoLoginFlag {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSMutableArray *autoLoginInfoArray = [umpApiManager.umpExtractDataFromLocalDB extractDataFromAutoLogin];
    if ([autoLoginInfoArray count] == 0) {
        return nil;
    } else {
        NSInteger allow_autologin = (long)[autoLoginInfoArray objectAtIndex:4];
        if (allow_autologin == 0) {
            return nil;
        } else {
            NSString *uid = [autoLoginInfoArray objectAtIndex:0];
            NSString *login_token = [autoLoginInfoArray objectAtIndex:1];
            
            NSMutableDictionary *dataMutableDic = [[NSMutableDictionary alloc] init];
            [dataMutableDic setObject:uid forKey:@"uid"];
            [dataMutableDic setObject:login_token forKey:@"login_token"];
            NSDictionary *dataDic = [[NSDictionary alloc] initWithDictionary:dataMutableDic];
            
            return dataDic;
        }
    }
}


- (NSDictionary *)talkToServerToLoginWithDataDic:(NSDictionary *)dataDic {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = [dataDic objectForKey:@"uid"];
    NSString *login_token = [dataDic objectForKey:@"login_token"];
    
    NSString *message = [[NSString alloc] initWithFormat:@"?uid=%@&login_token=%@", uid, login_token];
    NSMutableURLRequest *request = [umpApiManager.umpNetwork generateGETRequestForService:@"autologin" withMessage:message];
    NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    
    if (backDataDic == nil) {
        if (UMPME_DEBUG) NSLog(@"[debug][error][auto login bhv]back data dic is nil.");
        return nil;
    } else {
        NSData *connectionBackData = [backDataDic objectForKey:@"backData"];
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackData
                                 options:NSJSONReadingAllowFragments
                                 error:&jsonError];
        if (jsonError != nil) {
            if (UMPME_DEBUG) NSLog(@"[debug][error][auto login bhv].");
            return nil;
        } else {
            if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"no"]) {
                if (UMPME_DEBUG) NSLog(@"[debug][error][auto login bhv]succ is no.");
                if (UMPME_DEBUG) NSLog(@"[debug][error][auto login bhv][succ is no]error = %@.", [jsonDic objectForKey:@"error"]);
                if (UMPME_DEBUG) NSLog(@"[debug][error][auto login bhv][succ is no]uid = %@.", [jsonDic objectForKey:@"uid"]);
                return nil;
            } else {
                NSMutableDictionary *willBackDataMutableDic = [[NSMutableDictionary alloc] init];
                [willBackDataMutableDic setObject:[jsonDic objectForKey:@"uid"] forKey:@"uid"];
                [willBackDataMutableDic setObject:[jsonDic objectForKey:@"login_id"] forKey:@"login_id"];
                NSDictionary *willBackDataDic = [[NSDictionary alloc] initWithDictionary:willBackDataMutableDic];
                return willBackDataDic;
            }
        }
    }
}

- (BOOL)updateLocalLoginTableWithDataDic:(NSDictionary *)dataDic {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = [dataDic objectForKey:@"uid"];
    NSString *login_id = [dataDic objectForKey:@"login_id"];
    
    NSString *updateSQL = [[NSString alloc] initWithFormat:@"UPDATE login SET login_id=%@ WHERE uid=%@", login_id, uid];
    if ([umpApiManager.umpLocalDB openLocalDB] &&
        [umpApiManager.umpLocalDB updateDataOnLocalDB:updateSQL] &&
        [umpApiManager.umpLocalDB closeLocalDB]) return YES;
    
    return NO;
}

- (BOOL)downloadAndWriteUnreadIntMsgToLocalDBForUid:(NSString *)uid {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSArray *unreadIntMsgInstanceArray = [umpApiManager.umpDownloadData downloadIntMsgTableUnreadMsgForUid:uid];
    if (unreadIntMsgInstanceArray != nil) {
        return [umpApiManager.umpSyncToLocalDB
                syncToLocalDB_InsertDataToIntMsgReceiveTableForUid:uid
                withDataArray:unreadIntMsgInstanceArray];
    }
    return YES;
}

- (BOOL)connectIntMsgServiceForUid:(NSString *)uid {
    // Do something.
    return YES;
}




@end









