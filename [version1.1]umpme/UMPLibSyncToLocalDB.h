//
//  UMPLibSyncToLocalDB.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMPLibApiManager;
@interface UMPLibSyncToLocalDB : NSObject

+ (id)shareSyncToLocalDBManager;

- (BOOL)syncToLocalDB_InsertDataToAutoLoginTableWithDataDic:(NSDictionary *)dataDic;
- (BOOL)syncToLocalDB_InsertDataToAutoLoginTableWithSQL:(NSString *)sqlSentence;
- (BOOL)syncToLocalDB_updateAutoLoginFlagToAutoLoginTableWithDataDic:(NSDictionary *)dataDic;
- (BOOL)syncToLocalDB_updateAutoLoginAllDataToAutoLoginTableWithDataDic:(NSDictionary *)dataDic;
//- (BOOL)syncToLocalDB_InsertDataToLoginTableWithDataDic:(NSDictionary *)dataDic;
- (BOOL)syncToLocalDB_InsertDataToIntMsgReceiveTableForUid:(NSString *)uid withDataArray:(NSArray *)dataArray;

@end
