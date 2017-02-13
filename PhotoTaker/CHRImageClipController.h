//
//  ImageClipViewController.h
//  ClipPhoto
//
//  Created by DLL on 15/11/11.
//  Copyright © 2015年 DLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHRImageClipController;

// 回调不会关闭Controller，需要手动关闭。
@protocol CHRImageClipControllerDelegate <NSObject>


- (void)imageClipController:(CHRImageClipController *)viewController didFinishClipImage:(UIImage *)image;

- (void)imageClipControllerDidCancel:(CHRImageClipController *)viewController;

@end

@interface CHRImageClipController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@property (weak, nonatomic) id<CHRImageClipControllerDelegate> delegate;

@end
