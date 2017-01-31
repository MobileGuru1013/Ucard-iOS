//
//  CommunityCollectionViewCell.h
//  Ucard
//
//  Created by WuLeilei on 15/5/7.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *priseLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *countryLabel;

+ (CGFloat)width;

@end
