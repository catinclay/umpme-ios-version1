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


@end
