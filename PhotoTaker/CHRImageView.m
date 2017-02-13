//
//  CHRImageView.m
//  ChinaHR
//
//  Created by DLL on 16/3/29.
//  Copyright © 2016年 xuewu. All rights reserved.
//

#import "CHRImageView.h"

@interface CHRImageView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation CHRImageView {
    UIImageView *_backgroundImageView;
    UIImageView *_imageView;
    UIScrollView *_scrollView;
    BOOL _show;
    
    BOOL _doubleClickHasPerformed;
}

@dynamic image;

#pragma mark - life cycle
- (instancetype)initWithImage:(UIImage *)image {
    self = [self init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self imageViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self imageViewInit];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    return self;
}

- (void)imageViewInit {
    self.backgroundColor = [UIColor clearColor];
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_backgroundImageView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _scrollView.clipsToBounds = NO;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2;
    _scrollView.bouncesZoom = NO;
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    
    UIGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
    singleClick.delegate = self;
    [self addGestureRecognizer:singleClick];
    
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
    doubleClick.delegate = self;
    doubleClick.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleClick];
}

#pragma mark - method
- (void)show {
    if (_show) {
        return;
    }
    _show = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage imageFromScreen];
        image = [image gaussBlur:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            _backgroundImageView.image = image;
        });
    });
    
    
    [[DLLMaskWindow defaultWindow] showModalView:self animated:YES touchOutsideCancel:NO hide:NULL];
}

- (void)dismiss {
    if (!_show) {
        return;
    }
    _show = NO;
    [[DLLMaskWindow defaultWindow] hideModalView:self animated:YES];
}

- (void)singleClick:(id)sender {
    _doubleClickHasPerformed = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_doubleClickHasPerformed) {
            [self dismiss];
        }
    });
}

- (void)doubleClick:(id)sender {
    _doubleClickHasPerformed = YES;
    if (_scrollView.zoomScale != _scrollView.maximumZoomScale) {
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    } else {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    }
}

#pragma mark - property
- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    if (image == nil) {
        return;
    }
    _scrollView.zoomScale = 1;
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return _scrollView;
}

- (UIImage *)image {
    return _imageView.image;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}



@end
