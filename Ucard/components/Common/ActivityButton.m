//
//  ActivityButton.m
//  Ucard
//
//  Created by Conner Wu on 15-4-13.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "ActivityButton.h"

@interface ActivityButton ()
{
    NSString *_title;
    UIActivityIndicatorView *_indicatorView;
}
@end

@implementation ActivityButton

- (id)init
{
    if (self = [super init]) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidesWhenStopped = YES;
        [_indicatorView stopAnimating];
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _indicatorView.center = CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    if (title && title.length > 0) {
        _title = title;
    }
}

- (void)startLoading
{
    [self setTitle:nil forState:UIControlStateNormal];
    
    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
    
    self.enabled = NO;
}

- (void)stopLoading
{
    [self setTitle:_title forState:UIControlStateNormal];
    
    [_indicatorView stopAnimating];
    
    self.enabled = YES;
}

@end
