//
//  CommunityDetailViewController.h
//  Ucard
//
//  Created by Conner Wu on 15/5/8.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "CommonBackViewController.h"
#import "CommunityDetaiModel.h"

@interface CommunityDetailViewController : CommonBackViewController

@property (nonatomic, assign) CommunityDetaiModel *listModel;
@property (nonatomic, strong) NSString *cardId;

@end
