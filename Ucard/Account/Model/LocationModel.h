//
//  LocationModel.h
//  Ucard
//
//  Created by Nguyễn Hữu Dũng on 12/4/15.
//  Copyright (c) 2015 Ucard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface LocationModel : JSONModel
@property (nonatomic, strong) NSNumber *location_id;
@property (nonatomic, strong) NSString *location_name;
@property (nonatomic, strong) NSString *location_country;


@end
