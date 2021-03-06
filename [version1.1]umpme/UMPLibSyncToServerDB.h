//
//  UMPLibSyncToServerDB.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMPLibApiManager;

@interface UMPLibSyncToServerDB : NSObject

+ (id)shareSyncToServerDBManager;

- (BOOL)syncToServerDB_updateAutoLoginFlagToAutoLoginTableWithDataDic:(NSDictionary *)dataDic;

@end
