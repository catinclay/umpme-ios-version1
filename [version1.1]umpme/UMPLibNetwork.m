//
//  UMPLibNetwork.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/16/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibNetwork.h"

@implementation UMPLibNetwork


+ (id)shareNetWorkManager {
    static UMPLibNetwork *umpNetwork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpNetwork = [[UMPLibNetwork alloc] init];
    });
    return umpNetwork;
}

- (id)init {
    if (self = [super init]) {
        UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
        self.umpHostAddress = umpCsntManager.umpCsntNetworkManager.umpHostAddress;
        self.umpServerWeirdString = umpCsntManager.umpCsntNetworkManager.umpServerWeirdString;
        self.umpDeviceCategory = umpCsntManager.umpCsntNetworkManager.umpDeviceCategory;
        self.umpDevice = umpCsntManager.umpCsntNetworkManager.umpDevice;
    }
    return self;
}


- (NSMutableURLRequest *)generateGETRequestForService:(NSString *)service withMessage:(NSString *)message {
    
    NSString *wholeURLString = [[NSString alloc]
                                initWithFormat:@"%@/%@/%@/%@/get/%@/%@",
                                self.umpHostAddress,
                                self.umpServerWeirdString,
                                self.umpDeviceCategory,
                                self.umpDevice,
                                service,
                                message];
    NSURL *url = [[NSURL alloc] initWithString:wholeURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_GET];
    
    return request;
}

- (NSMutableURLRequest *)generatePOSTRequestForService:(NSString *)service withContentType:(NSString *)umpContentType withPostBody:(NSData *)postBody {
    
    NSString *wholeURLString = [[NSString alloc]
                                initWithFormat:@"%@/%@/%@/%@/post/%@/",
                                self.umpHostAddress,
                                self.umpServerWeirdString,
                                self.umpDeviceCategory,
                                self.umpDevice,
                                service];
    
    NSURL *url = [[NSURL alloc] initWithString:wholeURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:TIMEOUT_POST];
    [request setValue:umpContentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    
    return request;
    
}

- (NSDictionary *)communicateWithServerWithRequest:(NSMutableURLRequest *)request {
    
    __block BOOL communicateDone = NO;
    NSCondition *condition = [NSCondition new];
    [condition lock];
    
    __block NSURLResponse *connectionBackResponse;
    __block NSData *connectionBackDate;
    __block NSError *connectionBackError;
    
    NSOperationQueue *connectionQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:connectionQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        connectionBackResponse = response;
        connectionBackDate = data;
        connectionBackError = connectionError;
        
        [condition lock];
        communicateDone = YES;
        [condition signal];
        [condition unlock];
    }];
    
    while (!communicateDone) {
        [condition wait];
    }
    [condition unlock];
    
    NSDictionary *connectionBackDic = nil;
    if (connectionBackError == nil) {
        NSMutableDictionary *connectionBackMutableDic = [[NSMutableDictionary alloc] init];
        [connectionBackMutableDic setObject:connectionBackResponse forKey:@"backResponse"];
        [connectionBackMutableDic setObject:connectionBackDate forKey:@"backData"];
        connectionBackDic = [[NSDictionary alloc] initWithDictionary:connectionBackMutableDic];
    }
    
    return connectionBackDic;
}


@end









