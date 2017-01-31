//
//  LocationViewController.h
//  Ucard
//
//  Created by Nguyễn Hữu Dũng on 30/11/2015.
//  Copyright (c) Năm 2015 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonBackViewController.h"
#import "BaseViewController.h"


@interface LocationViewController : CommonBackViewController
@property (nonatomic, strong) void (^updateLocation) ();
@property (nonatomic, assign) NSInteger * locationID;
@end
