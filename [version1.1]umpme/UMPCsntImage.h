//
//  UMPCsntImage.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/22/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMPCsntImage : NSObject

@property (strong, nonatomic) NSString *umpUBigImageData;
@property (strong, nonatomic) NSString *umpUSmallImageData;

+ (id)shareCnstImageManager;

@end
