//
//  UMPBhvManager.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/18/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPBhvSignup.h"
#import "UMPBhvLogin.h"

@interface UMPBhvManager : NSObject

// Signup
@property (strong, nonatomic) UMPBhvSignup *umpBhvSignup;
// Login
@property (strong, nonatomic) UMPBhvLogin *umpBhvLogin;

+ (id)shareBhvManager;

@end
