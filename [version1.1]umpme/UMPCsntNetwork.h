//
//  UMPCsntNetwork.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMPCsntNetwork : NSObject

@property (strong, nonatomic) NSString *umpHostAddress;
@property (strong, nonatomic) NSString *umpServerWeirdString;
@property (strong, nonatomic) NSString *umpDeviceCategory;
@property (strong, nonatomic) NSString *umpDevice;

+ (id)shareCsntNetworkManager;

@end
