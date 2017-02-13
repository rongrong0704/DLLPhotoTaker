//
//  DLLClipAvatarView.m
//  ClipPhoto
//
//  Created by DLL on 15/11/11.
//  Copyright © 2015年 DLL. All rights reserved.
//

#import "DLLCaptureImageView.h"


@interface DLLCaptureImageViewMaskLayer : CALayer

@property (strong, nonatomic) UIColor *maskColor;
@property (strong, nonatomic) UIColor *centerStrokeColor;
@property (assign, nonatomic) CGSize captureSize;

@end

@implementation DLLCaptureImageViewMaskLayer

- (void)drawInContext:(CGContextRef)ctx {
    CGSize size = self.bounds.size;
    CGContextSetFillColorWithColor(ctx, _maskColor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    CGRect centerRect = CGRectMake((size.width - _captureSize.width) / 2, (size.height  - _captureSize.height) / 2, _captureSize.width, _captureSize.height);
    CGContextClearRect(ctx, centerRect);
    
    CGContextSetStrokeColorWithColor(ctx, _centerStrokeColor.CGColor);
    CGContextStrokeRect(ctx, centerRect);
}

@end



@interface DLLCaptureImageView () <UIScrollViewDelegate>

@end

@implementation DLLCaptureImageView {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    DLLCaptureImageViewMaskLayer *_maskLayer;
}

@dynamic image;
@dynamic maskColor;
@dynamic centerStrokeColor;

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self captureImageViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self captureImageViewInit];
    }
    return self;
}

- (void)captureImageViewInit {
    self.userInteractionEnabled = YES;
    _maxZoomScale = 5;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.bounces = NO;
    _scrollView.bouncesZoom = NO;
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
    [self addSubview:_scrollView];
    
    _maskLayer = [DLLCaptureImageViewMaskLayer layer];
    _maskLayer.maskColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskLayer.centerStrokeColor = [UIColor clearColor];
    [self.layer addSublayer:_maskLayer];
    self.captureSize = CGSizeMake(200, 200);
}

- (void)layoutImage {
    CGSize size = self.bounds.size;
    
    _maskLayer.frame = self.bounds;
    _scrollView.minimumZoomScale = 0;
    _scrollView.maximumZoomScale = CGFLOAT_MAX;
    _scrollView.zoomScale = 1;
    _scrollView.frame = CGRectMake((size.width - _captureSize.width) / 2, (size.height - _captureSize.height) / 2, _captureSize.width, _captureSize.height);
    _scrollView.contentSize = _imageView.image.size;
    _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
    
    CGFloat scale = MAX(_captureSize.width / _imageView.image.size.width, _captureSize.height / _imageView.image.size.height);
    _scrollView.minimumZoomScale = scale;
    _scrollView.maximumZoomScale = scale * _maxZoomScale;
    [_scrollView setZoomScale:scale animated:NO];
    _scrollView.contentOffset = CGPointMake((_imageView.bounds.size.width * scale - _captureSize.width) / 2, (_imageView.bounds.size.height * scale - _captureSize.height) / 2);
    [_maskLayer setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_imageView.image) {
        [self layoutImage];
    }
}



#pragma mark - getter & setter
- (UIColor *)maskColor {
    return _maskLayer.maskColor;
}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskLayer.maskColor = maskColor;
}

- (UIColor *)centerStrokeColor {
    return _maskLayer.centerStrokeColor;
}

- (void)setCenterStrokeColor:(UIColor *)centerStrokeColor {
    _maskLayer.centerStrokeColor = centerStrokeColor;
}

- (void)setCaptureSize:(CGSize)captureSize {
    _captureSize = captureSize;
    _maskLayer.captureSize = captureSize;
}


- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self layoutImage];
}



- (UIImage *)image {
    return _imageView.image;
}

- (UIImage *)captureImage {
    CGFloat scale = _scrollView.zoomScale;
    CGRect rect = CGRectMake(_scrollView.contentOffset.x / scale, _scrollView.contentOffset.y / scale, _captureSize.width / scale, _captureSize.height / scale);
    UIImage *captureImage = [_imageView.image clipImageWithRect:rect];
    return captureImage;
}

#pragma mark - touch event
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return _scrollView;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}


@end
