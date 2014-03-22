//
//  UMPCsntImage.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/22/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCsntImage.h"

@implementation UMPCsntImage

+ (id)shareCnstImageManager {
    static UMPCsntImage *umpImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpImage = [[UMPCsntImage alloc] init];
    });
    return umpImage;
}

@end
