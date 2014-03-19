//
//  UMPLibDownloadData.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibDownloadData.h"

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
                                    generateGETRequestForDeviceCategory:@"mobile"
                                    forDevice:@"ios"
                                    forService:@"downloadautologintabledata"
                                    withMessage:message];
    
    NSDictionary *connectionBackDataDic = [umpApiManager.umpNetwork
                                           communicateWithServerWithRequest:request];
    
    
    NSData *connectionBackData = [connectionBackDataDic objectForKeyedSubscript:@"backData"];
    NSError *connectionBackError = [connectionBackDataDic objectForKeyedSubscript:@"backError"];
    
    if ([connectionBackData length] > 0 && connectionBackError == nil) {
        
    }
    
}

@end
