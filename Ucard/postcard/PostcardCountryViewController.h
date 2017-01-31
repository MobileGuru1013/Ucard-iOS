//
//  PostcardCountryViewController.h
//  Ucard
//
//  Created by Conner Wu on 15/4/28.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryModel.h"

@interface PostcardCountryViewController : UITableViewController

@property (nonatomic, strong) void (^countryBlock) (CountryModel *country);
@property (nonatomic, assign) BOOL onlyEnglish;

@end
