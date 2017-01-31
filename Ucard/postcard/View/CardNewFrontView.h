//
//  CardNewFrontView.h
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "LPImageResizingScrollView.h"

@interface CardNewFrontView : LPImageResizingScrollView

- (void)setContent:(BOOL)newImage;
- (void)clipImageView;
- (void)resetScrollView;

@end
