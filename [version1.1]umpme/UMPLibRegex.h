//
//  UMPLibRegex.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMPLibRegex : NSObject


+ (id)shareRegexManager;

- (BOOL)isEmailAddress:(NSString *)emailAddress;
- (BOOL)isPassword:(NSString *)password;



@end
