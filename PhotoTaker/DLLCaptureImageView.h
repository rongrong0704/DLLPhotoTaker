//
//  DLLClipAvatarView.h
//  ClipPhoto
//
//  Created by DLL on 15/11/11.
//  Copyright © 2015年 DLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLLCaptureImageView : UIView

/**
 *  遮罩层的颜色
 */
@property (strong, nonatomic) UIColor *maskColor;

/**
 *  中间取景框的边框颜色
 */
@property (strong, nonatomic) UIColor *centerStrokeColor;

/**
 *  要剪裁的图片
 */
@property (strong, nonatomic) UIImage *image;

/**
 *  取景大小
 */
@property (assign, nonatomic) CGSize captureSize;

/**
 *  最大可放大的倍数
 */
@property (assign, nonatomic) CGFloat maxZoomScale;


/**
 *  获取剪裁之后的照片
 *
 *  @return 剪裁生成的照片
 */
- (UIImage *)captureImage;

@end
