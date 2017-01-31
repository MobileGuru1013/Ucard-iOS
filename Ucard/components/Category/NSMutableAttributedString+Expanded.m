//
//  NSMutableAttributedString+xpand.m
//  BusyBodyCustomer
//
//  Created by Mac on 10/7/15.
//  Copyright (c) 2015 Duong. All rights reserved.
//

#import "NSMutableAttributedString+Expanded.h"

@implementation NSMutableAttributedString(Expanded)
-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color
{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}
-(void)setFontForText:(NSString*) textToFind andSize:(NSInteger)size{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:range];
    }
    
}
-(void)setSttrikeForOldPriceAfterText:(NSString*) text
{
    NSRange range = [self.mutableString rangeOfString:text options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        [self addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(range.location, self.length-range.location)];

    }

}
@end
