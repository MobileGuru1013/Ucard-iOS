//
//  NSString+Size.h
//  Ucard
//
//  Created by WuLeilei on 15/5/10.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGFloat)getHeightOfFont:(UIFont *)textFont width:(CGFloat)textWidth;
- (CGFloat)getWidthOfFont:(UIFont *)textFont height:(CGFloat)textHeight;

@end
