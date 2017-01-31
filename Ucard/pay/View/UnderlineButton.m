//
//  UnderlineButton.m
//  PateoII
//
//  Created by Conner Wu on 14-5-16.
//  Copyright (c) 2014年 Pateo. All rights reserved.
//

#import "UnderlineButton.h"

@implementation UnderlineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect frame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName: self.titleLabel.font}
                                                      context:nil];
    CGSize fontSize = frame.size;
    
    // Get the fonts color.
    // Sets the color to draw the line
    CGContextSetRGBStrokeColor(ctx, _r, _g, _b, _a); // Format : RGBA
    // Line Width : make thinner or bigger if you want
    CGContextSetLineWidth(ctx, 1.0f);
    
    // Calculate the starting point (left) and target (right)
    CGPoint l = CGPointMake(self.frame.size.width/2.0 - fontSize.width/2.0,
                            self.frame.size.height/2.0 +fontSize.height/2.0);
    CGPoint r = CGPointMake(self.frame.size.width/2.0 + fontSize.width/2.0,
                            self.frame.size.height/2.0 + fontSize.height/2.0);
    
    // Add Move Command to point the draw cursor to the starting point
    CGContextMoveToPoint(ctx, l.x, l.y);
    
    // Add Command to draw a Line
    CGContextAddLineToPoint(ctx, r.x, r.y);
    
    // Actually draw the line.
    CGContextStrokePath(ctx);
    
    // should be nothing, but who knows...
    [super drawRect:rect];
}

@end
