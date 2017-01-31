//
//  SignPopView.m
//  Ucard
//
//  Created by Conner Wu on 15/4/20.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "SignPopView.h"
#import "SmoothLineView.h"
#import "NSUserDefaults+Helpers.h"
#import "CardBasePopView.h"

@interface SignPopView ()
{
    SmoothLineView *_signView;
}
@end

static void saveApplier(void *info, const CGPathElement *element)
{
    NSMutableArray *array = (__bridge NSMutableArray *)info;
    
    int nPoints;
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            nPoints = 1;
            break;
        case kCGPathElementAddLineToPoint:
            nPoints = 1;
            break;
        case kCGPathElementAddQuadCurveToPoint:
            nPoints = 2;
            break;
        case kCGPathElementAddCurveToPoint:
            nPoints = 3;
            break;
        case kCGPathElementCloseSubpath:
            nPoints = 0;
            break;
        default:
            [array replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
            return;
    }
    
    NSNumber *type = [NSNumber numberWithInt:element->type];
    NSData *points = [NSData dataWithBytes:element->points length:nPoints * sizeof(CGPoint)];
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:type, @"type", points, @"points", nil]];
    
}

@implementation SignPopView

- (id)initWithFrame:(CGRect)frame bgFrame:(CGRect)bgFrame title:(NSString *)title
{
    if (self = [super initWithFrame:frame bgFrame:bgFrame title:title]) {
        _signView = [[SmoothLineView alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - 44 * 2)];
        
        _signView.lineWidth = 4.0f;
        [_bgView addSubview:_signView];
        
        CGMutablePathRef pathRef = [self getPath];
        if (pathRef) {
            _signView.path = pathRef;
            [_signView setNeedsDisplay];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_signView.frame];
        imageView.backgroundColor = [UIColor whiteColor];
        [_bgView insertSubview:imageView belowSubview:_signView];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_signView.frame), CGRectGetWidth(_signView.frame), 1)];
        line.backgroundColor = [UIColor colorWithCGColor:_bgView.layer.borderColor];
        [_bgView addSubview:line];
        
        UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeSystem];
        redoButton.frame = CGRectMake(5, CGRectGetMaxY(line.frame), (CGRectGetWidth(_bgView.frame)/2)-10, 44);
        redoButton.backgroundColor=kGColor;
        [redoButton setTitle:NSLocalizedString(@"localized118", nil) forState:UIControlStateNormal];
        [redoButton setTitleColor:[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1] forState:UIControlStateNormal];
        [redoButton addTarget:self action:@selector(redoMethod) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:redoButton];
        
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
        done.frame = CGRectMake(CGRectGetMaxX(redoButton.frame)+10, CGRectGetMaxY(line.frame), (CGRectGetWidth(_bgView.frame)/2)-10, 44);
        done.backgroundColor=kGColor;
        [done setTitle:NSLocalizedString(@"localized117", nil) forState:UIControlStateNormal];
        [done setTitleColor:[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1] forState:UIControlStateNormal];
        [done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:done];
        
        
        //        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        cancelButton.frame = CGRectMake(CGRectGetWidth(bgFrame) - 50 - 9+ 20,10, 20, 20);
        //        [cancelButton setImage:[UIImage imageNamed:@"Signature_cancel"] forState:UIControlStateNormal];
        //        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        //        [_bgView addSubview:cancelButton];
        //        _closeButton = cancelButton;
        
        
        [self hideCancel];
        
        
    }
    return self;
}

- (void)redoMethod
{
    [_signView clear];
}

- (void)done
{
    [self savePath];
    
    UIGraphicsBeginImageContextWithOptions(_signView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    _signView.backgroundColor = [UIColor clearColor];
    [_signView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [Singleton shareInstance].cardModel.signImage = image;
    [[Singleton shareInstance].cardModel saveSignImage];
    
    [super done];
}

- (NSString *)signKey
{
    NSString *key = [NSString stringWithFormat:@"Sign-%@", [Singleton shareInstance].uid];
    return key;
}

- (BOOL)savePath
{
    if (!_signView.path) {
        [NSUserDefaults deleteObjectForKey:[self signKey]];
        return YES;
    }
    // Convert path to an array
    NSMutableArray *a = [NSMutableArray arrayWithObject:[NSNumber numberWithBool:YES]];
    CGPathApply(_signView.path, (__bridge void *)(a), saveApplier);
    if (![[a objectAtIndex:0] boolValue]) {
        return NO;
    }
    [NSUserDefaults saveObject:a forKey:[self signKey]];
    return YES;
}

- (CGMutablePathRef)getPath
{
    NSArray *array = [NSUserDefaults retrieveObjectForKey:[self signKey]];
    if (!array) return nil;
    
    CGMutablePathRef p = CGPathCreateMutable();
    for (NSInteger i = 1, l = [array count]; i < l; i++) {
        NSDictionary *d = [array objectAtIndex:i];
        
        CGPoint *points = (CGPoint *) [[d objectForKey:@"points"] bytes];
        switch ([[d objectForKey:@"type"] intValue])
        {
            case kCGPathElementMoveToPoint:
                CGPathMoveToPoint(p, NULL, points[0].x, points[0].y);
                break;
            case kCGPathElementAddLineToPoint:
                CGPathAddLineToPoint(p, NULL, points[0].x, points[0].y);
                break;
            case kCGPathElementAddQuadCurveToPoint:
                CGPathAddQuadCurveToPoint(p, NULL, points[0].x, points[0].y, points[1].x, points[1].y);
                break;
            case kCGPathElementAddCurveToPoint:
                CGPathAddCurveToPoint(p, NULL, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y);
                break;
            case kCGPathElementCloseSubpath:
                CGPathCloseSubpath(p);
                break;
            default:
                CGPathRelease(p);
                return NO;
        }
    }
    return p;
}

@end
