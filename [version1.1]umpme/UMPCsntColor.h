//
//  UMPCsntColor.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMPCsntColor : NSObject

@property (strong, nonatomic) UIColor *umpBlackColor;
@property (strong, nonatomic) UIColor *umpRedColor;
@property (strong, nonatomic) UIColor *umpGreenColor;


+ (id)shareCsntColorManager;

@end
