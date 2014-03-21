//
//  UMPBhvSignout.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/21/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMPLibApiManager;

@interface UMPBhvSignout : NSObject

+ (id)shareBhvSignoutManager;

- (BOOL)talkToServerSignoutForUid:(NSString *)uid andServerLoginId:(NSString *)server_login_id;
- (BOOL)disconnectIntMsgServiceForUid:(NSString *)uid;
- (BOOL)clearAutoLoginTableForCurrUser;
- (BOOL)dropLocalUserCacheTables;

@end
