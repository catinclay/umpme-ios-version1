//
//  UMPLibNetwork.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/16/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMPCsntManager.h"

#define TIMEOUT_GET 10.0f
#define TIMEOUT_POST 30.0f

@interface UMPLibNetwork : NSObject

@property (strong, nonatomic) NSString *umpHostAddress;
@property (strong, nonatomic) NSString *umpServerWeirdString;
@property (strong, nonatomic) NSString *umpDeviceCategory;
@property (strong, nonatomic) NSString *umpDevice;

+ (id)shareNetWorkManager;

- (NSMutableURLRequest *)generateGETRequestForService:(NSString *)service withMessage:(NSString *)message;

- (NSMutableURLRequest *)generatePOSTRequestForService:(NSString *)service withContentType:(NSString *)contentType withPostBody:(NSData *)postBody;

- (BOOL)uploadProfileImageForUid:(NSInteger *)uid withProfileImage:(UIImage *)profileImage;

- (UIImage *)downloadProfileImageForUid:(NSInteger *)uid withSizeCategory:(NSString *)sizeCategory;

- (NSDictionary *)communicateWithServerWithRequest:(NSMutableURLRequest *)request;


@end
