//
//  UMPCurrUser.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/23/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMPCurrUser : NSObject

@property (strong, nonatomic) NSString *currUid;
@property (strong, nonatomic) NSArray *friendsIdsArray;


+ (id)shareCurrUserManager;


@end
