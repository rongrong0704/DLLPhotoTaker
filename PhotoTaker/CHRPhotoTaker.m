//
//  CHRPhotoTaker.m
//  ChinaHR
//
//  Created by Rong on 16/3/3.
//  Copyright © 2016年 xuewu. All rights reserved.
//

#import "CHRPhotoTaker.h"


@interface CHRPhotoTaker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CHRImageClipControllerDelegate, CHRCVActionSheetDelegate>

@end


@implementation CHRPhotoTaker
{
    void (^_pictureCallback)(UIImage *image);
    void (^_avatarCallback)(UIImage *image, NSString *filePath);

    UIViewController __weak *_parentViewController;
    UIImagePickerController __weak *_pickerController;
}

+ (instancetype)defaultPhotoTaker
{
    static dispatch_once_t token = 0;
    static CHRPhotoTaker *__taker;
    dispatch_once(&token, ^{
        __taker = [[CHRPhotoTaker alloc] init];
    });
    return __taker;
}

+ (void)takePictureWithParentViewController:(UIViewController *)viewController andResultCallback:(void (^)(UIImage *))callback
{
    [[self defaultPhotoTaker] takePictureWithParentViewController:viewController title:@"选择照片" andResultCallback:callback];
}

+ (CHRCVActionSheet *)takeAvatarWithParentViewController:(UIViewController *)viewController andCallback:(void (^)(UIImage *, NSString *))callback
{
    return [[self defaultPhotoTaker] takeAvatarWithParentViewController:viewController andCallback:callback];
}

- (CHRCVActionSheet *)takePictureWithParentViewController:(UIViewController *)viewController title:(NSString *)title andResultCallback:(void (^)(UIImage *))callback
{
    _pictureCallback = [callback copy];
    _parentViewController = viewController;

    CHRCVActionSheet *actionSheet = [CHRCVActionSheet viewWithType:CHRCVActionSheetTypePictrue];
    actionSheet.delegate = self;
    [actionSheet show];
    return actionSheet;
}

- (CHRCVActionSheet *)takeAvatarWithParentViewController:(UIViewController *)viewController andCallback:(void (^)(UIImage *, NSString *))callback
{
    _avatarCallback = [callback copy];
    return [self takePictureWithParentViewController:viewController title:@"上传头像" andResultCallback:^(UIImage *image) {
        if (image) {
            CHRImageClipController *controller = [[CHRImageClipController alloc] initWithImage:image];
            controller.delegate = self;
            [_parentViewController presentViewController:controller animated:YES completion:NULL];
        }
    }];
}

/**
 *  拍照
 */
- (void)takePicture
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        controller.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        [_parentViewController presentViewController:controller animated:YES completion:NULL];
        _pickerController = controller;
    } else {
        TOAST(@"该设备不支持拍照");
    }
}

/**
 *  从相册选择
 */
- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [_parentViewController presentViewController:controller animated:YES completion:NULL];
        _pickerController = controller;
    } else {
        TOAST(@"该设备不支持相册");
    }
}

- (NSString *)tempFilePath
{
    return [DLLFilePathUtil tempPath:@"chinahrtemppic.jpg"];
}


#pragma mark - action sheet delegate
- (void)cvActionSheet:(CHRCVActionSheet *)sheet didSelectItem:(NSString *)item atIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self selectPhoto];
            break;
        case 1:
            [self takePicture];
        default:
            break;
    }
}

- (void)cvActionSheetDidSelectCancel:(CHRCVActionSheet *)sheet
{
    _pictureCallback = nil;
}

#pragma mark - image picker controller delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:^{
        if (_pictureCallback) {
            _pictureCallback(nil);
        }
        _pictureCallback = nil;
        _avatarCallback = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:NO completion:^{
        if (_pictureCallback) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            _pictureCallback(image);
        }
        _pictureCallback = nil;
    }];
}

#pragma mark - image clip controller delegate
- (void)imageClipController:(CHRImageClipController *)viewController didFinishClipImage:(UIImage *)image
{
    if (_avatarCallback) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *filePath = [self tempFilePath];
            BOOL success = [image writeToFile:filePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                _avatarCallback(image, success ? filePath : nil);
                _avatarCallback = nil;
            });
        });
    }
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imageClipControllerDidCancel:(CHRImageClipController *)viewController
{
    if (_avatarCallback) {
        _avatarCallback(nil, nil);
    }
    _avatarCallback = nil;
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}
@end
