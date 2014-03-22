//
//  UMPLibExtractDataFromLocalDB.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/19/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMPLibApiManager;

@interface UMPLibExtractDataFromLocalDB : NSObject

+ (id)shareExtractDataFromLocalDBManager;

- (NSMutableArray *)extractDataFromAutoLogin;
- (NSString *)getCurrUserUid;
- (NSString *)getCurrLoginServerId;

@end
