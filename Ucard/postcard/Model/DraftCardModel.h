//
//  DraftCardModel.h
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "BaseModel.h"

@interface DraftCardModel : BaseModel

@property (nonatomic, assign) NSInteger cardId;

@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, assign) float saturate;
@property (nonatomic, assign) float brightness;
@property (nonatomic, assign) float contrast;
@property (nonatomic, assign) BOOL frame;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger fontIndex;
@property (nonatomic, assign) NSInteger sizeIndex;

@property (nonatomic, strong) NSString *signName;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *countryId;
@property (nonatomic, strong) NSString *photoAddress;

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) UIImage *signImage;

// 正反面截图名称
@property (nonatomic, strong) NSString *frontName;
@property (nonatomic, strong) NSString *backName;


@property (nonatomic, assign) NSInteger stamp;
@property (nonatomic, assign) NSInteger color;
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *captionText;


// 上传后的ID
@property (nonatomic, strong) NSString *remoteCardId;

// 是否已上传
@property (nonatomic, assign) BOOL hasUploaded;

- (BOOL)insert;
+ (DraftCardModel *)select;
+ (void)deleteData;
- (BOOL)updateData;

- (UIImage *)cachePhoto;
- (void)savePhoto;

- (void)saveSignImage;
- (NSString *)getSignImagePath;

- (void)saveBgImage:(UIImage *)image;
- (UIImage *)getBgImage;

- (void)screenshotFront:(UIImage *)image;
- (void)screenshotBack:(UIImage *)view;
- (void)screenshotUploadBack:(UIImage *)image;
- (NSString *)frontPath;
- (NSString *)backUploadPath;
- (NSString *)backPath;

@end
