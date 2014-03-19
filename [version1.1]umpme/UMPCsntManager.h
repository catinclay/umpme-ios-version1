//
//  UMPCsntManager.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPCsntNetwork.h"
#import "UMPCsntLocalDB.h"
#import "UMPCsntDateTime.h"
#import "UMPCsntColor.h"
#import "UMPCsntSegue.h"

@interface UMPCsntManager : NSObject

@property (strong, nonatomic) UMPCsntNetwork *umpCsntNetworkManager;
@property (strong, nonatomic) UMPCsntLocalDB *umpCsntLocalDBManager;
@property (strong, nonatomic) UMPCsntDateTime *umpCsntDateTimeManager;
@property (strong, nonatomic) UMPCsntColor *umpCsntColorManager;
@property (strong, nonatomic) UMPCsntSegue *umpCsntSegueManager;

+ (id)shareCsntManager;

@end
