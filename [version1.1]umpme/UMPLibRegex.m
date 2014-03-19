//
//  UMPLibRegex.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibRegex.h"

@implementation UMPLibRegex

+ (id)shareRegexManager {
    static UMPLibRegex *regexManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexManager = [[UMPLibRegex alloc] init];
    });
    return regexManager;
}

- (BOOL)isEmailAddress:(NSString *)emailAddress {
    if ([emailAddress length] == 0) return NO; // Check input validation.
    
    NSString *emailAddressRegexString = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSError *regexError = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:emailAddressRegexString
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&regexError];
    
    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:emailAddress
                                  options:0
                                  range:NSMakeRange(0, [emailAddress length])];
    
    
    if (numberOfMatches > 0) return YES;
    else return  NO;
}

- (BOOL)isPassword:(NSString *)password {
    if ([password length] == 0) return NO; // Check input validation.
    
    NSString *passwordRegexString = @"^(?=.{6,32}$)(?=.*\\d)(?=.*[a-zA-Z]).*$";
    NSError *regexError = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:passwordRegexString
                                  options:0
                                  error:&regexError];
    
    NSUInteger numberOfMatches = [regex
                                  numberOfMatchesInString:password
                                  options:0
                                  range:NSMakeRange(0, [password length])];
    
    if (numberOfMatches > 0) return YES;
    else return NO;
}




@end
