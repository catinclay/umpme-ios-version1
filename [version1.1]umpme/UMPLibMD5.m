//
//  UMPLibMD5.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibMD5.h"

@implementation UMPLibMD5


+ (id)shareMD5Manager {
    static UMPLibMD5 *umpMD5Manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpMD5Manager = [[UMPLibMD5 alloc] init];
    });
    return umpMD5Manager;
}

- (NSString *)convertStringToMD5:(NSString *)givenString {
    if ([givenString length] == 0) return nil; // Check the empty input.
    const char *cStr = [givenString UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
