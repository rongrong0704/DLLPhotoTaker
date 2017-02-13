//
//  ImageClipViewController.m
//  ClipPhoto
//
//  Created by DLL on 15/11/11.
//  Copyright © 2015年 DLL. All rights reserved.
//

#import "CHRImageClipController.h"
#import "DLLCaptureImageView.h"


@interface CHRImageClipController ()

@end

@implementation CHRImageClipController {
    UIImage *_image;
    DLLCaptureImageView *_captureImageView;
}


- (instancetype)initWithImage:(UIImage *)image {
    self = [self init];
    if (self) {
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    _captureImageView = [[DLLCaptureImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _captureImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _captureImageView.image = _image;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _captureImageView.captureSize = CGSizeMake(screenWidth, screenWidth);
    [self.view addSubview:_captureImageView];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width / 2, 50);
    btnClose.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [btnClose setTitle:@"取 消" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
    btnClose.titleLabel.font = [UIFont lightFontOfSize:18];
    [self.view addSubview:btnClose];
    
    UIButton *btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 50, self.view.bounds.size.width / 2, 50);
    [btnFinish setTitle:@"确 定" forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFinish addTarget:self action:@selector(clickFinish:) forControlEvents:UIControlEventTouchUpInside];
    btnFinish.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:btnFinish];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 40, 0.5, 30)];
    seperator.backgroundColor = [UIColor whiteColor];
    seperator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:seperator];
}

- (void)clickClose:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(imageClipControllerDidCancel:)]) {
        [_delegate imageClipControllerDidCancel:self];
    }
}

- (void)clickFinish:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(imageClipController:didFinishClipImage:)]) {
        // 计算图片的缩放
        UIImage *clipedImage = [_captureImageView captureImage];
        clipedImage = [clipedImage imageWithScaledToSize:CGSizeMake(400, 400)];
        [_delegate imageClipController:self didFinishClipImage:clipedImage];
    }
}


@end
