//
//  LPImageResizingScrollView.m
//  Lunarpad
//
//  Created by Paul Shapiro.
//  Copyright (c) 2014 Lunarpad. All rights reserved.
//

#import "LPImageResizingScrollView.h"
#import "UIImage+Resizing.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface LPImageResizingScrollView ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation LPImageResizingScrollView


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [self teardown];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup

- (void)setup
{
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    self.minZoomScale = 1.0f;
    self.maxZoomScale = 5.0f;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Teardown

- (void)teardown
{
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors

- (UIImage *)croppedImage
{
    return [self croppedImage:self.image];
}

- (UIImage *)croppedImage:(UIImage *)image
{    
    float imageScale = sqrtf(powf(self.imageView.transform.a, 2.f) + powf(self.imageView.transform.c, 2.f));
    CGFloat widthScale = self.imageView.bounds.size.width / self.imageView.image.size.width;
    CGFloat heightScale = self.imageView.bounds.size.height / self.imageView.image.size.height;
    float contentScale = MIN(widthScale, heightScale);
    float effectiveScale = imageScale * contentScale;
    CGFloat oX = self.contentOffset.x;
    CGFloat oY = self.contentOffset.y;    
    CGAffineTransform rectRotationTransform;
    switch (image.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            rectRotationTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI/2), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            rectRotationTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI/2), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            rectRotationTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI), -image.size.width, -image.size.height);
            break;
        default:
            rectRotationTransform = CGAffineTransformIdentity;
    };
    rectRotationTransform = CGAffineTransformScale(rectRotationTransform, image.scale, image.scale);
    CGRect rawCropRect = CGRectMake(oX/effectiveScale, oY/effectiveScale, self.bounds.size.width/effectiveScale, self.bounds.size.height/effectiveScale);
    CGRect cropRect = CGRectApplyAffineTransform(rawCropRect, rectRotationTransform);

//    NSLog(@"Info: cropRect %@", NSStringFromCGRect(cropRect));
//    NSLog(@"Info: imageScale %f", effectiveScale);
//    NSLog(@"Info: effectiveScale %f", effectiveScale);
//    NSLog(@"Info: oX %f oY %f", oX, oY);
//    NSLog(@"Info: self.bounds.size.width / effectiveScale %f", self.bounds.size.width / effectiveScale);
//    NSLog(@"Info: self.bounds.size.height / effectiveScale %f", self.bounds.size.height / effectiveScale);
    
    // doesn't handle clipping properly for some reason
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
//    NSLog(@"Info: result  %@", NSStringFromCGSize(result.size));

    if (result.size.width > kMaximumThingImageWidth || result.size.height > kMaximumThingImageHeight) {
        result = [result scaleToFitSize:(CGSize){kMaximumThingImageWidth, kMaximumThingImageHeight}];
//        NSLog(@"Info: Scale it!");
    }
    
//    NSLog(@"Info: result now %@", NSStringFromCGSize(result.size));

    return result;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    [Singleton shareInstance].cardModel.hasUploaded = NO;
    [[Singleton shareInstance].cardModel updateData];
    
    return self.imageView;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Imperatives

- (void)setImageViewImage:(UIImage *)image
{
    self.image = image;
    self.imageView.image = self.image;
}

- (void)configureWithImage:(UIImage *)image andPreZoomPadding:(CGFloat)preZoomPadding
{
    self.image = image;
    
    [self setMinimumZoomScale:self.minZoomScale];
    [self setMaximumZoomScale:self.maxZoomScale];    
    [self loadPhotoWithPreZoomPadding:preZoomPadding];
}

- (void)loadPhotoWithPreZoomPadding:(CGFloat)preZoomPadding
{
    if (self.imageView) {
        if (self.imageView.superview) {
            [self.imageView removeFromSuperview];
        }
        self.imageView = nil;
    }
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    BOOL widthIsSmaller = imageWidth <= imageHeight;
    
    CGFloat smallerSelfSideLength = widthIsSmaller ? self.frame.size.width : self.frame.size.height;
    CGFloat smallerImageSideLength = widthIsSmaller ? imageWidth : imageHeight;
    CGFloat contentInnerLength = smallerSelfSideLength + preZoomPadding;
    CGFloat scaleFactor = contentInnerLength / smallerImageSideLength;
    
    CGFloat innerW = self.image.size.width * scaleFactor;
    CGFloat innerH = self.image.size.height * scaleFactor;
    
    float destWith = innerW;
    float destHeight = innerH;
    
    if (innerW < CGRectGetWidth(self.frame)) {
        destWith = (CGRectGetWidth(self.frame) / CGRectGetHeight(self.frame)) * destHeight;
    } else if (innerH < CGRectGetHeight(self.frame)) {
        destHeight = (CGRectGetHeight(self.frame) / CGRectGetWidth(self.frame)) * destWith;
    }
    
    CGRect imageViewFrame = CGRectMake(0.0f, 0.0f, destWith, destHeight);
    self.contentSize = imageViewFrame.size;
    
    self.contentOffset = CGPointMake((destWith - self.frame.size.width)/2, (destHeight - self.frame.size.height)/2); // center the view
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = self.image;
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [Singleton shareInstance].cardModel.hasUploaded = NO;
    [[Singleton shareInstance].cardModel updateData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [Singleton shareInstance].cardModel.hasUploaded = NO;
    [[Singleton shareInstance].cardModel updateData];
}

@end
