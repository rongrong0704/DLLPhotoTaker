//
//  CHRImageView.h
//  ChinaHR
//
//  Created by DLL on 16/3/29.
//  Copyright © 2016年 xuewu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHRImageView : UIView

- (instancetype)initWithImage:(UIImage *)image;

@property (strong, nonatomic) UIImage *image;

- (void)show;

- (void)dismiss;
@end
