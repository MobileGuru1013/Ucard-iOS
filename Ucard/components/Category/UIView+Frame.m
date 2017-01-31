//
//  UIView+Frame.m
//
//  Created by Daniel Shein on 2/14/12.
//  Copyright (c) 2012 LoFT. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - Shortcuts for the coords

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - Shortcuts for frame properties

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
#pragma mark - Shortcuts for positions

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark - Rect Setters

-(void)setFrameWidth:(CGFloat)_width
{
    CGRect newFrame = self.frame;
    newFrame.size.width = _width;
    self.frame = newFrame;
}


-(void)setFrameHeight:(CGFloat)_height
{
    CGRect newFrame = self.frame;
    newFrame.size.height = _height;
    self.frame = newFrame;
}


-(void)setFrameOriginX:(CGFloat)_x
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = _x;
    self.frame = newFrame;
}


-(void)setFrameOriginY:(CGFloat)_y
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = _y;
    self.frame = newFrame;    
}

-(void)setFrameOrigin:(CGPoint)_point
{
    CGRect newFrame = self.frame;
    newFrame.origin = _point;
    self.frame = newFrame;
}


-(void)setFrameSize:(CGSize)_size
{
    CGRect newFrame = self.frame;
    newFrame.size = _size;
    self.frame = newFrame;    
}

#pragma mark - Rect Movement Methods

-(void)modifyFrameWidthBy:(CGFloat)_width
{
    CGRect newFrame = self.frame;
    newFrame.size.width += _width;
    self.frame = newFrame;
}

-(void)modifyFrameHeightBy:(CGFloat)_height
{
    CGRect newFrame = self.frame;
    newFrame.size.height += _height;
    self.frame = newFrame;    
}

-(void)modifyFrameOriginXBy:(CGFloat)_x
{
    CGRect newFrame = self.frame;
    newFrame.origin.x += _x;
    self.frame = newFrame;    
}

-(void)modifyFrameOriginYBy:(CGFloat)_y
{
    CGRect newFrame = self.frame;
    newFrame.origin.y += _y;
    self.frame = newFrame;    
}

-(void)modifyFrameOrigin:(CGPoint)_point
{
    CGRect newFrame = self.frame;
    newFrame.origin.x += _point.x;
    newFrame.origin.y += _point.y;
    self.frame = newFrame;
}

-(void)modifyFrameSize:(CGSize)_size
{
    CGRect newFrame = self.frame;
    newFrame.size.width += _size.width;
    newFrame.size.height += _size.height;
    self.frame = newFrame;
}
@end
