//
//  NSMutableAttributedString+xpand.h
//  BusyBodyCustomer
//
//  Created by Mac on 10/7/15.
//  Copyright (c) 2015 Duong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString(Expanded)
-(void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color;
-(void)setSttrikeForOldPriceAfterText:(NSString*) text;
-(void)setFontForText:(NSString*) textToFind andSize:(NSInteger)size;
@end
