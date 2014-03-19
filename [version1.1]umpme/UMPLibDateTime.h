//
//  UMPLibDateTime.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/17/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPCsntManager.h"

@interface UMPLibDateTime : NSObject

+(id)shareDateTimeManager;

- (NSString *)getUmpDate;
- (NSString *)getUmpTime;

@end
