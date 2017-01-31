//
//  ProfileHeaderTableViewCell.h
//  Ucard
//
//  Created by WuLeilei on 15/5/1.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProfileHeaderTableViewCellHeight 60

@interface ProfileHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *userName;

@end
