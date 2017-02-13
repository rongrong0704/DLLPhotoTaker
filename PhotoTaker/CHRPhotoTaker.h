//
//  CHRPhotoTaker.h
//  ChinaHR
//
//  Created by Rong on 16/3/3.
//  Copyright © 2016年 xuewu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHRImageClipController.h"
#import "CHRCVActionSheet.h"

@interface CHRPhotoTaker : NSObject

/**
 *  弹出下框获取图片
 *
 *  @param viewController 父视图控制器
 *  @param callback       图片选择的回调
 */
+ (void)takePictureWithParentViewController:(UIViewController *)viewController andResultCallback:(void(^)(UIImage *image))callback;

/**
 *  获取头像，先取照片再切割
 *
 *  @param viewController 父视图控制器
 *  @param callback       图片选择的回调
 *
 *  @return 弹出的action sheet视图
 */
+ (CHRCVActionSheet *)takeAvatarWithParentViewController:(UIViewController *)viewController andCallback:(void (^)(UIImage *image, NSString *filePath))callback;

@end
