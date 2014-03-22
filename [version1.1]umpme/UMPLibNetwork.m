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
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:TIMEOUT_POST];
    [request setValue:umpContentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    
    return request;
    
}

//- (BOOL)uploadProfileImageForUid:(NSInteger *)uid withProfileImage:(UIImage *)profileImage {
//    
//    NSString *uidString = [[NSString alloc] initWithFormat:@"%ld", (long)uid];
//    
//    NSData *profileImagePNGRepresentation = UIImagePNGRepresentation(profileImage);
//    NSString *profileImageBase64String = [profileImagePNGRepresentation
//                                          base64EncodedStringWithOptions:
//                                          NSDataBase64Encoding64CharacterLineLength];
//    
//    NSMutableDictionary *profileImageDic = [[NSMutableDictionary alloc] init];
//    [profileImageDic setObject:uidString forKey:@"uid"];
//    [profileImageDic setObject:profileImageBase64String forKey:@"profileImage"];
//    
//    NSError *encodingJsonError = nil;
//    NSData *profileImageDicJson = [NSJSONSerialization
//                                   dataWithJSONObject:profileImageDic
//                                   options:NSJSONWritingPrettyPrinted error:&encodingJsonError];
//    
//    if (encodingJsonError == nil) {
//        __block BOOL uploadSuccessful = NO;
//        NSMutableURLRequest *request = [self
//                                        generatePOSTRequestForService:@"uploadprofileimage"
//                                        withContentType:@"application/json"
//                                        withPostBody:profileImageDicJson];
//        
//        NSOperationQueue *connectionQueue = [[NSOperationQueue alloc] init];
//        [NSURLConnection sendAsynchronousRequest:request queue:connectionQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            
//            if ([data length] > 0 && connectionError == nil) {
//                
//                uploadSuccessful = YES;
//                
//            } else if ([data length] == 0) {
//                if (DEBUG) NSLog(@"[Debug][Error][UMPAPI][Network][uploadProfileImage]No data comes back from server.");
//                uploadSuccessful = NO;
//                
//            } else {
//                if (DEBUG) NSLog(@"[Debug][Error][UMPAPI][Network][uploadProfileImage]Error during connecting network.");
//                uploadSuccessful = NO;
//            }
//            
//        }];
//        
//        return uploadSuccessful;
//        
//    } else {
//        if (DEBUG) NSLog(@"[Debug][Error]Fail to encode profile image dic into json.");
//        return NO;
//    }
//    
//}

//- (UIImage *)downloadProfileImageForUid:(NSInteger *)uid withSizeCategory:(NSString *)sizeCategory {
//    NSString *requestMessage = [[NSString alloc] initWithFormat:@"?uid=%ld", (long)uid];
//    
//    NSMutableURLRequest *request = [self
//                                    generateGETRequestForService:@"downloadprofileimage"
//                                    withMessage:requestMessage];
//    
//    __block UIImage *profileImage = nil;
//    
//    NSOperationQueue *connectionQueue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:connectionQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        if ([data length] > 0 && connectionError == nil) {
//            NSError *decodingJsonError = nil;
//            NSDictionary *imageDic = [NSJSONSerialization
//                                      JSONObjectWithData:data
//                                      options:NSJSONReadingAllowFragments
//                                      error:&decodingJsonError];
//            
//            if (decodingJsonError == nil) {
//                NSString *profileImageBase64String = [imageDic objectForKey:@"profileimage"];
//                NSData *profileImageData = [[NSData alloc]
//                                            initWithBase64EncodedString:profileImageBase64String
//                                            options:0];
//                profileImage = [[UIImage alloc] initWithData:profileImageData];
//                
//            } else {
//                if (DEBUG) NSLog(@"[Debug][Error][UMPAPI][Network][downloadProfileImage]Can not decode json.");
//            }
//            
//        } else if ([data length] == 0) {
//            if (DEBUG) NSLog(@"[Debug][Error][UMPAPI][Network][downloadProfileImage]No data comes back from server.");
//        } else {
//            if (DEBUG) NSLog(@"[Debug][Error][UMPAPI][Network][downloadProfileImage]Error during connecting network.");
//        }
//    }];
//    
//    return profileImage;
//}

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









