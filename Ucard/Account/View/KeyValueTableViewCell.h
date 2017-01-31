//
//  KeyValueTableViewCell.h
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKeyValueTableViewCellHeight 44

@interface KeyValueTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end
