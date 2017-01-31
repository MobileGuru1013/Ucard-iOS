//
//  LPImageResizingScrollView.h
//  Lunarpad
//
//  Created by Paul Shapiro.
//  Copyright (c) 2014 Lunarpad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPImageResizingScrollView;


////////////////////////////////////////////////////////////////////////////////

const static CGFloat kMaximumThingImageWidth = 1000.0f;
const static CGFloat kMaximumThingImageHeight = 1000.0f;


////////////////////////////////////////////////////////////////////////////////

@protocol LPImageResizingDelegate <NSObject>

- (void)photoCropper:(LPImageResizingScrollView *)photoCropper didCropPhoto:(UIImage *)photo;

@end


////////////////////////////////////////////////////////////////////////////////

@interface LPImageResizingScrollView : UIScrollView
<
    UIScrollViewDelegate
>

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, assign) CGFloat minZoomScale;
@property (nonatomic, assign) CGFloat maxZoomScale;
@property (nonatomic, unsafe_unretained) id<LPImageResizingDelegate> imageResizingDelegate;

- (UIImage *)croppedImage;
- (UIImage *)croppedImage:(UIImage *)image;
- (void)configureWithImage:(UIImage *)image andPreZoomPadding:(CGFloat)preZoomPadding;
- (void)setImageViewImage:(UIImage *)image;

@end
