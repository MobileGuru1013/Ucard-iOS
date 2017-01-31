//
//  CardNewFrontView.m
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CardNewFrontView.h"
#import "GPUImageBrightnessFilter.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageContrastFilter.h"
#import "GPUImageFilterGroup.h"
#import "GPUImagePicture.h"

@interface CardNewFrontView ()

@end

@implementation CardNewFrontView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setContent:(BOOL)newImage
{
    [self performSelectorInBackground:@selector(setContentInBackground:) withObject:[NSNumber numberWithBool:newImage]];
}

- (void)setContentInBackground:(NSNumber *)newImage
{
    UIImage *image = [Singleton shareInstance].cardModel.photoImage;
    
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    
    [brightnessFilter addTarget:saturationFilter];
    [saturationFilter addTarget:contrastFilter];
    
    if ([Singleton shareInstance].cardModel.brightness != 1.0) {
        brightnessFilter.brightness = [Singleton shareInstance].cardModel.brightness - 1.0f;
    }
    
    if ([Singleton shareInstance].cardModel.saturate != 1.0) {
        saturationFilter.saturation = [Singleton shareInstance].cardModel.saturate;
    }
    
    if ([Singleton shareInstance].cardModel.contrast != 1.0) {
        contrastFilter.contrast = [Singleton shareInstance].cardModel.contrast;
    }
    
    GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc] init];
    [groupFilter addFilter:brightnessFilter];
    [groupFilter addFilter:saturationFilter];
    [groupFilter addFilter:contrastFilter];
    [groupFilter setInitialFilters:@[brightnessFilter]];
    [groupFilter setTerminalFilter:contrastFilter];
    
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:image];
    [imagePicture addTarget:groupFilter];
    [contrastFilter useNextFrameForImageCapture];
    [imagePicture processImage];
    image = [contrastFilter imageFromCurrentFramebufferWithOrientation:image.imageOrientation];
    
    [self performSelectorOnMainThread:@selector(showContentImage:) withObject:@[image, newImage] waitUntilDone:YES];
    
}

- (void)showContentImage:(NSArray *)arg
{
   
    UIImage *image = [arg firstObject];
    if (!image) {
        return;
    }
    BOOL newImage = [[arg lastObject] boolValue];
    if (newImage) {
        [self configureWithImage:image andPreZoomPadding:1.0f];
    } else {
        [self setImageViewImage:image];
    }
}

- (void)resetScrollView
{
    self.zoomScale = 1.0;
    self.contentSize = self.bounds.size;
    self.contentOffset = CGPointZero;
}

// 裁剪图片并保存
- (void)clipImageView
{

    // 正面画图并保存
    [self drawImage];
}

// 正面画图
- (void)drawImage
{
    UIImage *newImage = [self croppedImage];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kCardWidth, kCardHeight), NO, 1.0);
    
    // 图片
    [newImage drawInRect:CGRectMake(0, 0, kCardWidth, kCardHeight)];
    
    // 边框
    if ([Singleton shareInstance].cardModel.frame) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIGraphicsPushContext(context);
        
        CGFloat height = 10 * kCardWidth / CGRectGetWidth(self.imageView.frame);
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, kCardWidth, height));
        CGContextFillRect(context, CGRectMake(kCardWidth - height, 0, height, kCardHeight));
        CGContextFillRect(context, CGRectMake(0, kCardHeight - height, kCardWidth, height));
        CGContextFillRect(context, CGRectMake(0, 0, height, kCardHeight));
        
        UIGraphicsPopContext();
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[Singleton shareInstance].cardModel screenshotFront:image];
}

@end
