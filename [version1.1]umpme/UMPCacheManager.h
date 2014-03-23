//
//  UMPCacheManager.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPCurrUser.h"

@interface UMPCacheManager : NSObject

@property (strong, nonatomic) UMPCurrUser *umpCurrUser;

+ (id)shareCacheManager;

@end
