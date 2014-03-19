//
//  UMPLibMD5.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface UMPLibMD5 : NSObject

+ (id)shareMD5Manager;

- (NSString *)convertStringToMD5:(NSString *)givenString;

@end
