//
//  UMPLibApiManager.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPLibRegex.h"
#import "UMPLibLocalDB.h"
#import "UMPLibMD5.h"
#import "UMPLibNetwork.h"
#import "UMPLibDateTime.h"
#import "UMPLibDownloadData.h"
#import "UMPLibSyncToLocalDB.h"

@interface UMPLibApiManager : NSObject

// Regex.
@property (strong, nonatomic) UMPLibRegex *umpRegex;

// Local DB.
@property (strong, nonatomic) UMPLibLocalDB *umpLocalDB;

// MD5.
@property (strong, nonatomic) UMPLibMD5 *umpMD5;

// Network.
@property (strong, nonatomic) UMPLibNetwork *umpNetwork;

// DateTime.
@property (strong, nonatomic) UMPLibDateTime *umpDateTime;

// Download Data
@property (strong, nonatomic) UMPLibDownloadData *umpDownloadData;

// Sync to local DB.
@property (strong, nonatomic) UMPLibSyncToLocalDB *umpSyncToLocalDB;

+ (id)shareApiManager;

@end
