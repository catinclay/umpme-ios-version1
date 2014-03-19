//
//  UMPCsntColor.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCsntColor.h"

@implementation UMPCsntColor

+ (id)shareCsntColorManager {
    static UMPCsntColor *umpCsntColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCsntColor = [[UMPCsntColor alloc] init];
    });
    return umpCsntColor;
}

- (id)init {
    if (self = [super init]) {
        self.umpBlackColor = [UIColor blackColor];
        self.umpRedColor = [UIColor
                            colorWithRed:231/255.0f
                            green:76/255.0f
                            blue:60/255.0f
                            alpha:1.0];
    }
    return self;
}

@end
