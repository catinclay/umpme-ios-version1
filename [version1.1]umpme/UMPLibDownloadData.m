//
//  UMPLibDownloadData.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibDownloadData.h"
#import "UMPLibApiManager.h"

@implementation UMPLibDownloadData

+ (id)shareDownloadDataManager {
    static UMPLibDownloadData *umpDownloadDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpDownloadDataManager = [[UMPLibDownloadData alloc] init];
    });
    return umpDownloadDataManager;
}

- (NSDictionary *)downloadAutoLoginTableDataForUid:(NSString *)uid {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    NSDictionary *dataDic = nil;
    NSString *message = [[NSString alloc] initWithFormat:@"?uid=%@", uid];
    NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                    generateGETRequestForService:@"downloadautologintabledata"
                                    withMessage:message];
    
    NSDictionary *connectionBackDataDic = [umpApiManager.umpNetwork
                                           communicateWithServerWithRequest:request];
    
    if (connectionBackDataDic == nil) return nil;
    
    NSData *connectionBackData = [connectionBackDataDic objectForKeyedSubscript:@"backData"];
    
    NSMutableDictionary *dataMutableDic = [[NSMutableDictionary alloc] init];
    
    if ([connectionBackData length] > 0) {
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackData
                                 options:NSJSONReadingAllowFragments error:&jsonError];
        
        if (jsonError == nil) {
            if ([[jsonDic objectForKey:@"error"] isEqualToString:@"no"]) {
                [dataMutableDic setObject:[jsonDic objectForKey:@"uid"] forKey:@"uid"];
                [dataMutableDic setObject:[jsonDic objectForKey:@"ulogin_token"] forKey:@"ulogin_token"];
                [dataMutableDic setObject:[jsonDic objectForKey:@"token_update_date"]
                                   forKey:@"token_update_date"];
                [dataMutableDic setObject:[jsonDic objectForKey:@"token_update_time"]
                                   forKey:@"token_update_time"];
                [dataMutableDic setObject:[jsonDic objectForKey:@"allow_autologin"]
                                   forKey:@"allow_autologin"];
                
                dataDic = [[NSDictionary alloc] initWithDictionary:dataMutableDic];
            }
        }
    }
    return dataDic;
}

- (NSDictionary *)downloadLoginSignoutTableDataForUid:(NSString *)uid {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *message = [[NSString alloc] initWithFormat:@"?uid=%@", uid];
    
    NSMutableURLRequest *request = [umpApiManager.umpNetwork generateGETRequestForService:@"downloadloginsignouttabledata" withMessage:message];
    
    NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    
    NSDictionary *dataDic = nil;
    
    if (backDataDic != nil) {
        
        NSData *connectionBackData = [backDataDic objectForKey:@"backData"];
        
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackData
                                 options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError == nil) {
            
            if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"yes"]) {
                
                NSString *login_server_id = [jsonDic objectForKey:@"login_server_id"];
                
                NSString *login_date = [jsonDic objectForKey:@"login_date"];
                NSString *login_time = [jsonDic objectForKey:@"login_time"];
                NSString *signout_date = [jsonDic objectForKey:@"signout_date"];
                NSString *signout_time = [jsonDic objectForKey:@"signout_time"];
                
                NSMutableDictionary *dataMutableDic = [[NSMutableDictionary alloc] init];
                [dataMutableDic setObject:uid forKey:@"uid"];
                [dataMutableDic setObject:login_server_id forKey:@"login_server_id"];
                [dataMutableDic setObject:login_date forKey:@"login_date"];
                [dataMutableDic setObject:login_time forKey:@"login_time"];
                [dataMutableDic setObject:signout_date forKey:@"signout_date"];
                [dataMutableDic setObject:signout_time forKey:@"signout_time"];
                
                dataDic = [[NSDictionary alloc] initWithDictionary:dataMutableDic];
            }
        }
    }
    return dataDic;
}

- (NSArray *)downloadIntMsgTableUnreadMsgForUid:(NSString *)uid {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *message = [[NSString alloc] initWithFormat:@"?uid=%@", uid];
    NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                    generateGETRequestForService:@"downloadunreadintmsg"
                                    withMessage:message];
    NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    if (backDataDic != nil) {
        NSData *connectionBackDataDic = [backDataDic objectForKey:@"backData"];
        
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackDataDic
                                 options:NSJSONReadingAllowFragments
                                 error:&jsonError];
        if (jsonError != nil) {
            if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"yes"]) {
                
                NSArray *unreadIntMsgInstanceArray = [jsonDic objectForKey:@"unread_msg_instance_list"];
                NSInteger unreadIntMsgInstanceNum = [unreadIntMsgInstanceArray count];
                if (unreadIntMsgInstanceNum != 0) return unreadIntMsgInstanceArray;
            }
        }
    }
    return nil;
}





@end








