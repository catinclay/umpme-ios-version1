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

- (BOOL)syncToLocalDB_InsertDataToAutoLoginTableForUid:(NSString *)uid;
//- (BOOL)syncToLocalDB_UpdateDataToAutoLoginTableForUid:(NSString *)uid;

@end
