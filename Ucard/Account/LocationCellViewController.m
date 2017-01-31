//
//  LocationCellViewController.m
//  Ucard
//
//  Created by Nguyễn Hữu Dũng on 30/11/2015.
//  Copyright (c) Năm 2015 Ucard. All rights reserved.
//

#import "LocationCellViewController.h"

@implementation LocationCellViewController

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        
        _locationlb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 50)];
        _locationlb.textColor=[UIColor grayColor];
        [self.contentView addSubview:_locationlb];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
