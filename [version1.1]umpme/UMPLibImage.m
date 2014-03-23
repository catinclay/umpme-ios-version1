//
//  UMPLibImage.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/22/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibImage.h"
#import "UMPLibApiManager.h"


@implementation UMPLibImage

+ (id)shareImageManager {
    static UMPLibImage *umpImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpImage = [[UMPLibImage alloc] init];
    });
    return umpImage;
}

//- (BOOL)uploadImage:(UIImage *)uImage withCompressionQuality:(CGFloat)compressionQuality forUid:(NSString *)uid withService:(NSString *)service {
//    
//    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
//    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
//    
//    NSData *uImageJPEGRepresentation = UIImageJPEGRepresentation(uImage, compressionQuality);
//    NSString *uImageBase64String = [uImageJPEGRepresentation
//                                    base64EncodedStringWithOptions:
//                                    NSDataBase64Encoding64CharacterLineLength];
//    
//    NSMutableDictionary *uImageDic = [[NSMutableDictionary alloc] init];
//    [uImageDic setObject:uid forKey:@"uid"];
//    [uImageDic setObject:uImageBase64String forKey:@"uImageB64String"];
//    
//    NSError *jsonEncodeError = nil;
//    NSData *uImageDicJson = [NSJSONSerialization
//                             dataWithJSONObject:uImageDic
//                             options:NSJSONWritingPrettyPrinted error:&jsonEncodeError];
//    
//    if (jsonEncodeError == nil) {
//        
//        NSMutableURLRequest *request = [umpApiManager.umpNetwork
//                                        generatePOSTRequestForService:service
//                                        withContentType:umpCsntManager.umpCsntNetworkManager.umpPostContentType
//                                        withPostBody:uImageDicJson];
//        
//        NSDictionary *backData = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
//        if (backData == nil) {
//            if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]talk to server back data is nil.");
//            return NO;
//        } else {
//            
//            NSData *connectionBackData = [backData objectForKey:@"backData"];
//            NSError *jsonDecodeError = nil;
//            NSDictionary *jsonDic = [NSJSONSerialization
//                                     JSONObjectWithData:connectionBackData
//                                     options:NSJSONReadingAllowFragments
//                                     error:&jsonDecodeError];
//            if (jsonDecodeError != nil) {
//                if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]Json decode error.");
//                return NO;
//            } else {
//                if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"no"]) {
//                    if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]succ is no.");
//                    return NO;
//                } else {
//                    return YES;
//                }
//            }
//        }
//    } else {
//        if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]Json encode error.");
//        return NO;
//    }
//}

- (BOOL)uploadImagesOfBothSizeWithSourceImage:(UIImage *)simage withBigImageCompressionQualityDic:(CGFloat)bigImageCompressionQuality withSmallImageCompressionQuality:(CGFloat)smallImageCompressionQuality forUid:(NSString *)uid withService:(NSString *)service {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    
    NSData *bigImageJPEGRepresentation = UIImageJPEGRepresentation(simage, bigImageCompressionQuality);
    NSData *smallImageJPEGRepresentation = UIImageJPEGRepresentation(simage, smallImageCompressionQuality);
    
    NSString *bigImageBase64String = [bigImageJPEGRepresentation
                                      base64EncodedStringWithOptions:
                                      NSDataBase64Encoding64CharacterLineLength];
    
    NSString *smallImageBase64String = [smallImageJPEGRepresentation
                                        base64EncodedStringWithOptions:
                                        NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *uploadImagesDic = [[NSMutableDictionary alloc] init];
    [uploadImagesDic setObject:uid forKey:@"uid"];
    [uploadImagesDic setObject:bigImageBase64String forKey:@"big_imageb64string"];
    [uploadImagesDic setObject:smallImageBase64String forKey:@"small_imageb64string"];
    
    NSError *jsonEncodeError = nil;
    NSData *uImageDicJsonData = [NSJSONSerialization
                                 dataWithJSONObject:uploadImagesDic
                                 options:NSJSONWritingPrettyPrinted error:&jsonEncodeError];
    
    if (jsonEncodeError == nil) {
        
        NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                        generatePOSTRequestForService:service
                                        withContentType:umpCsntManager.umpCsntNetworkManager.umpPostContentType
                                        withPostBody:uImageDicJsonData];
        
        NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
        if (backDataDic == nil) {
            if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]talk to server back data dic is nil.");
            return NO;
        } else {
            
            NSData *connectionBackData = [backDataDic objectForKey:@"backData"];            
            NSError *jsonDecodeError = nil;
            NSDictionary *jsonDic = [NSJSONSerialization
                                     JSONObjectWithData:connectionBackData
                                     options:NSJSONReadingAllowFragments
                                     error:&jsonDecodeError];
            if (jsonDecodeError != nil) {
                if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]Json decode error. e = %@", jsonDecodeError);
                return NO;
            } else {
                if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"no"]) {
                    if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]succ is no.");
                    if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]error = %@", [jsonDic objectForKey:@"error"]);
                    return NO;
                } else {
                    return YES;
                }
            }
        }
    } else {
        if (UMPME_DEBUG) NSLog(@"[debug][error][image][upload image]Json encode error.");
        return NO;
    }
}

- (UIImage *)downloadSingleImageForUid:(NSString *)uid withService:(NSString *)service {
    
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *message = [[NSString alloc] initWithFormat:@"?uid=%@", uid];
    
    NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                    generateGETRequestForService:service
                                    withMessage:message];
    
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
    
    
    NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    if (backDataDic == nil) {
        return nil;
    } else {
        NSData *connectionBackData = [backDataDic objectForKey:@"backData"];
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackData options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError != nil) {
            if (UMPME_DEBUG) NSLog(@"[debug][error][ump lib image][download single image]json error.");
            return nil;
        } else {
            if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"no"]) {
                if (UMPME_DEBUG) NSLog(@"[debug][error][ump lib image][download single image]succ is no.");
                if (UMPME_DEBUG) NSLog(@"[debug][error][ump lib image][download single image]error = %@", [jsonDic objectForKey:@"error"]);
                return nil;
            } else {
                NSString *uImageBase64String = [jsonDic objectForKey:@"uimage"];
                NSData *uImageData = [[NSData alloc]
                                      initWithBase64EncodedString:uImageBase64String
                                      options:0];
                return [[UIImage alloc] initWithData:uImageData];
            }
        }
    }
    
}

- (NSDictionary *)downloadImageOfBothSizeForUid:(NSString *)uid withService:(NSString *)service {
    UMPLibApiManager *umpApiManager = [UMPLibApiManager shareApiManager];
    
    NSString *message = [[NSString alloc] initWithFormat:@"?uid=%@", uid];
    
    NSMutableURLRequest *request = [umpApiManager.umpNetwork
                                    generateGETRequestForService:service
                                    withMessage:message];
    
    
    NSDictionary *backDataDic = [umpApiManager.umpNetwork communicateWithServerWithRequest:request];
    if (backDataDic == nil) {
        return nil;
    } else {
        NSData *connectionBackData = [backDataDic objectForKey:@"backData"];
        NSError *jsonError = nil;
        NSDictionary *jsonDic = [NSJSONSerialization
                                 JSONObjectWithData:connectionBackData options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError != nil) {
            if (UMPME_DEBUG) NSLog(@"[debug][error][ump lib image][download single image]json error.");
            return nil;
        } else {
            if ([[jsonDic objectForKey:@"succ"] isEqualToString:@"no"]) {
                if (UMPME_DEBUG) NSLog(@"[debug][error][ump lib image][download single image]succ is no.");
                return nil;
            } else {
                NSString *uBigImageBase64String = [jsonDic objectForKey:@"ubigimage"];
                NSString *uSmallImageBase64String = [jsonDic objectForKey:@"usmallimage"];
                NSData *uBigImageData = [[NSData alloc]
                                         initWithBase64EncodedString:uBigImageBase64String
                                         options:0];
                NSData *uSmallImageData = [[NSData alloc]
                                           initWithBase64EncodedString:uSmallImageBase64String
                                           options:0];
                NSMutableDictionary *imagesMutableDic = [[NSMutableDictionary alloc] init];
                [imagesMutableDic setObject:uBigImageData forKey:@"ubigimagedata"];
                [imagesMutableDic setObject:uSmallImageData forKey:@"usmallimagedata"];
                
                return [[NSDictionary alloc] initWithDictionary:imagesMutableDic];
            }
        }
    }
}


@end











