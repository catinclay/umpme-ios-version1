//
//  UMPLibDownloadData.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UMPLibApiManager;
@interface UMPLibDownloadData : NSObject

+ (id)shareDownloadDataManager;

- (NSDictionary *)downloadAutoLoginTableDataForUid:(NSString *)uid;
- (NSDictionary *)downloadLoginSignoutTableDataForUid:(NSString *)uid;
- (NSArray *)downloadIntMsgTableUnreadMsgForUid:(NSString *)uid;

@end
