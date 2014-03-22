//
//  UMPLibImage.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/22/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMPLibApiManager;

@interface UMPLibImage : NSObject

+ (id)shareImageManager;

//- (BOOL)uploadImage:(UIImage *)uImage withCompressionQuality:(CGFloat)compressionQuality forUid:(NSString *)uid withService:(NSString *)service;
- (BOOL)uploadImagesOfBothSizeWithSourceImage:(UIImage *)simage withBigImageCompressionQualityDic:(CGFloat)bigImageCompressionQuality withSmallImageCompressionQuality:(CGFloat)smallImageCompressionQuality forUid:(NSString *)uid withService:(NSString *)service;
- (UIImage *)downloadSingleImageForUid:(NSString *)uid withService:(NSString *)service;
- (NSDictionary *)downloadImageOfBothSizeForUid:(NSString *)uid withService:(NSString *)service;

@end
