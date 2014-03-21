//
//  UMPBhvSignout.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/21/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPBhvSignout.h"
#import "UMPLibApiManager.h"

@implementation UMPBhvSignout

+ (id)shareBhvSignoutManager {
    static UMPBhvSignout *umpSignout = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpSignout = [[UMPBhvSignout alloc] init];
    });
    return umpSignout;
}

- (BOOL)talkToServerSignoutForUid:(NSString *)uid andServerLoginId:(NSString *)server_login_id {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *message = [[NSString alloc] initWithFormat:@"?uid=%@&server_login_id=%@", uid, server_login_id];
    NSMutableURLRequest *request = [umpApiManager.umpNetwork generateGETRequestForService:@"signout" withMessage:message];
    NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    if (backDataDic == nil) {
        return NO;
    } else {
        NSData *connectionBackData = [backDataDic objectForKey:@"backData"];
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackData
                                 options:NSJSONReadingAllowFragments
                                 error:&jsonError];
        if (jsonError != nil) {
            return NO;
        } else {
            if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"no"]) {
                return NO;
            } else {
                return YES;
            }
        }
    }
}

- (BOOL)disconnectIntMsgServiceForUid:(NSString *)uid {
    // Do something.
    return YES;
}

- (BOOL)clearAutoLoginTableForCurrUser {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    if ([umpApiManager.umpLocalDB openLocalDB] &&
        [umpApiManager.umpLocalDB clearAutoLoginTable] &&
        [umpApiManager.umpLocalDB closeLocalDB]) {
        
        return YES;
    }
    return NO;
}

- (BOOL)dropLocalUserCacheTables {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    if ([umpApiManager.umpLocalDB openLocalDB] &&
        [umpApiManager.umpLocalDB dropUserLocalCacheTables] &&
        [umpApiManager.umpLocalDB closeLocalDB]) {
        
        return YES;
    }
    return NO;
}


@end
