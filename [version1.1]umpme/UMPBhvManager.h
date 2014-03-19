//
//  UMPBhvManager.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPBhvSignup.h"

@interface UMPBhvManager : NSObject

// Signup
@property (strong, nonatomic) UMPBhvSignup *umpBhvSignup;

+ (id)shareBhvManager;

@end
