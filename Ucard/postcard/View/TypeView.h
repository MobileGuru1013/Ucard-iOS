//
//  TypeView.h
//  Ucard
//
//  Created by Nguyễn Hữu Dũng on 12/7/15.
//  Copyright (c) 2015 Ucard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardBasePopView.h"
#import "CountryModel.h"



@interface TypeView : CardBasePopView

@property (nonatomic, strong) CountryModel *countryModel;

@property (nonatomic, strong) void (^showCountryBlock) ();



@end
