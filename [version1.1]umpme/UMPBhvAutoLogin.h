//
//  UMPBhvAutoLogin.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/21/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMPLibApiManager;

@interface UMPBhvAutoLogin : NSObject

+ (id)shareBhvAutoLoginManager;

- (NSDictionary *)checkLocalAutoLoginFlag;
- (NSDictionary *)talkToServerToLoginWithDataDic:(NSDictionary *)dataDic;
- (BOOL)updateLocalLoginTableWithDataDic:(NSDictionary *)dataDic;
- (BOOL)downloadAndWriteUnreadIntMsgToLocalDBForUid:(NSString *)uid;
- (BOOL)connectIntMsgServiceForUid:(NSString *)uid;

@end
