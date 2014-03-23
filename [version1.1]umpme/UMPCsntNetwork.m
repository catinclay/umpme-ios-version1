//
//  UMPCsntNetwork.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPCsntNetwork.h"

@implementation UMPCsntNetwork

+ (id)shareCsntNetworkManager {
    static UMPCsntNetwork *umpCsntNetwork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpCsntNetwork = [[UMPCsntNetwork alloc] init];
    });
    return umpCsntNetwork;
}

- (id)init {
    if (self = [super init]) {
        //self.umpHostAddress = @"http://localhost:8000";
        self.umpHostAddress = @"http://www.umpme.com";
        self.umpServerWeirdString = @"iosisrealgoodsystemforumpme";
        self.umpDeviceCategory = @"mobile";
        self.umpDevice = @"ios";
        self.umpPostContentType = @"application/json";
        
        // Servce
        self.umpServiceGetFriendsIdsArray = @"getfriendsidsarray";
    }
    return self;
}

@end
