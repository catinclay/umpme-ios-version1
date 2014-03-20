//
//  UMPLibSyncToServerDB.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibSyncToServerDB.h"
#import "UMPLibApiManager.h"


@implementation UMPLibSyncToServerDB

+ (id)shareSyncToServerDBManager {
    static UMPLibSyncToServerDB *umpSyncToServerDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpSyncToServerDB = [[UMPLibSyncToServerDB alloc] init];
    });
    return umpSyncToServerDB;
}

- (BOOL)syncToServerDB_updateAutoLoginFlagToAutoLoginTableWithDataDic:(NSDictionary *)dataDic {
    
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *uid = [dataDic objectForKey:@"uid"];
    NSString *autoLoginSwitchStateString = [dataDic objectForKey:@"allow_autologin"];
    
    NSString *message = [[NSString alloc]
                         initWithFormat:@"?uid=%@&autologinflag=%@",
                         uid, autoLoginSwitchStateString];
    NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                    generateGETRequestForService:@"updateautologinflag"
                                    withMessage:message];
    
    NSDictionary *serverBackDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    
    if (serverBackDataDic != nil) {
        NSData *connectionBackData = [serverBackDataDic objectForKey:@"backData"];
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackData
                                 options:NSJSONReadingAllowFragments
                                 error:&jsonError];
        if (jsonError == nil) {
            NSString *backUpdateSucc = [jsonDic objectForKey:@"update_succ"];
            if ([backUpdateSucc isEqualToString:@"yes"]) { // successful.
                
                return YES;
                
            } else { // unsuccessful.
                return NO;
            }
            
        } else {
            return NO;
        }
        
    } else {
        return NO;
    }
}

@end
