//
//  UMPLibSyncBothSidesDB.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibSyncBothSidesDB.h"
#import "UMPLibApiManager.h"


@implementation UMPLibSyncBothSidesDB

+ (id)shareSyncBothSidesDBManager {
    static UMPLibSyncBothSidesDB *umpSyncBothSidesDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpSyncBothSidesDB = [[UMPLibSyncBothSidesDB alloc] init];
    });
    return umpSyncBothSidesDB;
}

- (BOOL)syncBothSides_Update_AutoLoginForUid:(NSString *)uid {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSArray *dataArrayOfLocalAutoLogin = [umpApiManager.umpExtractDataFromLocalDB extractDataFromAutoLoginWithUid:uid];
    
    NSUInteger is_sync = (long)[dataArrayOfLocalAutoLogin objectAtIndex:5];
    
    if (is_sync == 0) { // has not synced with server db.
        
        NSDictionary *dataDicOfServerAutoLogin = [umpApiManager.umpDownloadData downloadAutoLoginTableDataForUid:uid];
        
        if (dataDicOfServerAutoLogin != nil) {
            NSString *ulogin_token = [dataDicOfServerAutoLogin objectForKey:@"ulogin_token"];
            NSString *token_update_date = [dataDicOfServerAutoLogin objectForKey:@"token_update_date"];
            NSString *token_update_time = [dataDicOfServerAutoLogin objectForKey:@"token_update_time"];
            NSString *allow_autologin = [dataDicOfServerAutoLogin objectForKey:@"allow_autologin"];
            
            NSMutableDictionary *updateDataMutableDic = [[NSMutableDictionary alloc] init];
            [updateDataMutableDic setObject:uid forKey:@"uid"];
            [updateDataMutableDic setObject:ulogin_token forKey:@"ulogin_token"];
            [updateDataMutableDic setObject:token_update_date forKey:@"token_update_date"];
            [updateDataMutableDic setObject:token_update_time forKey:@"token_update_time"];
            [updateDataMutableDic setObject:allow_autologin forKey:@"allow_autologin"];
            [updateDataMutableDic setObject:@"1" forKey:@"is_sync"];
            
            return [umpApiManager.umpSyncToLocalDB syncToLocalDB_updateAutoLoginAllDataToAutoLoginTableWithDataDic:updateDataMutableDic];
            
        } else {
            return NO;
        }
        
    } else { // has synced with server db.
        return YES;
    }
    
}












@end
