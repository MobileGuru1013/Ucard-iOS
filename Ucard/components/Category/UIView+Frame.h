//
//  UIView+Frame.h
//
//  Created by Daniel Shein on 2/14/12.
//  Copyright (c) 2012 LoFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

// Rect Setters
-(void)setFrameWidth:(CGFloat)_width;
-(void)setFrameHeight:(CGFloat)_height;
-(void)setFrameOriginX:(CGFloat)_x;
-(void)setFrameOriginY:(CGFloat)_y;

-(void)setFrameOrigin:(CGPoint)_point;
-(void)setFrameSize:(CGSize)_size;

// Rect Movement Methods
-(void)modifyFrameWidthBy:(CGFloat)_width;
-(void)modifyFrameHeightBy:(CGFloat)_height;
-(void)modifyFrameOriginXBy:(CGFloat)_x;
-(void)modifyFrameOriginYBy:(CGFloat)_y;

-(void)modifyFrameOrigin:(CGPoint)_point;
-(void)modifyFrameSize:(CGSize)_size;

@end
