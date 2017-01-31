//
//  DraftCardModel.m
//  Ucard
//
//  Created by Conner Wu on 15-4-9.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "DraftCardModel.h"

@implementation DraftCardModel

- (id)init
{
    if (self = [super init]) {
        _text = @"";
        _signName = @"";
        _photoAddress = @"";
        _fontIndex = 0;
        _sizeIndex = 10;
        _hasUploaded = NO;
        _stamp = -1;
        _locationName = @"";
        _captionText = @"";
    }
    return self;
}

- (BOOL)insert
{
    [self savePhoto];
    
    [DraftCardModel deleteData];
    
    BOOL succ = [[DatabaseManager shareInstance].userDB executeUpdateWithFormat:@"INSERT INTO draft (photoName, fontIndex, sizeIndex) VALUES (%@, %ld, %ld)", _photoName, (long)_fontIndex, (long)_sizeIndex];
    if (!succ) {
        NSLog(@"%@", [[DatabaseManager shareInstance].userDB lastError]);
    }
    _cardId = [[DatabaseManager shareInstance].userDB lastInsertRowId];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDraftNotification" object:nil];
    
    return succ;
}

+ (DraftCardModel *)select
{
    DraftCardModel *model = [[DraftCardModel alloc] init];
    
    FMResultSet *rs = [[DatabaseManager shareInstance].userDB executeQuery:@"SELECT * FROM draft LIMIT 1"];
    if ([rs next]) {
        NSDictionary *dic = [rs resultDictionary];
        NSError *error;
        model = [[DraftCardModel alloc] initWithDictionary:dic error:&error];
        if (error) {
            NSLog(@"%@", error);
        } else {
            [model cachePhoto];
            [model cacheSign];
        }
    }
    return model;
}

+ (void)deleteData
{
    BOOL succ = [[DatabaseManager shareInstance].userDB executeUpdate:@"DELETE FROM draft"];
    if (!succ) {
        NSLog(@"%@", [[DatabaseManager shareInstance].userDB lastError]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDraftNotification" object:nil];
}

- (BOOL)updateData
{
    BOOL succ = [[DatabaseManager shareInstance].userDB executeUpdateWithFormat:@"UPDATE draft SET photoName = %@, saturate = %f, brightness = %f, contrast = %f, frame = %d, text = %@, signName = %@, firstName = %@, middleName = %@, lastName = %@, street = %@, building = %@, city = %@, province = %@, zip = %@, country = %@, countryId = %@, fontIndex = %ld, sizeIndex = %ld, remoteCardId = %@, hasUploaded = %d, color = %ld, stamp = %ld, location = %ld, locationName = %@, captionText = %@  WHERE cardId = %ld", _photoName, _saturate, _brightness, _contrast, _frame, _text, _signName, _firstName, _middleName, _lastName, _street, _building, _city, _province, _zip, _country, _countryId, (long)_fontIndex, (long)_sizeIndex, _remoteCardId, _hasUploaded, _color, _stamp, _location, _locationName, _captionText, (long)_cardId];
    if (!succ) {
        NSLog(@"%@", [[DatabaseManager shareInstance].userDB lastError]);
    }
    return succ;
}

#pragma mark 照片

- (void)savePhoto
{
    _photoName = [NSString stringWithFormat:@"%ld-photo.png", (long)_cardId];
    
    NSData *data = UIImagePNGRepresentation(_photoImage);
    if (!data) {
        data = UIImageJPEGRepresentation(_photoImage, 1.0);
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:[self cacheImagePath:_photoName] contents:data attributes:nil];
}

- (NSString *)cacheImagePath:(NSString *)imageName
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/%@", imageName];
    return path;
}

- (UIImage *)cachePhoto
{
    NSString *path = [self cacheImagePath:_photoName];
    _photoImage = [UIImage imageWithContentsOfFile:path];
    return _photoImage;
}

#pragma mark 签名

- (void)saveSignImage
{
    NSData *data;
    if (UIImagePNGRepresentation(_signImage) == nil) {
        data = UIImageJPEGRepresentation(_signImage, 1.0);
    } else {
        data = UIImagePNGRepresentation(_signImage);
    }
    
    _signName = [NSString stringWithFormat:@"%ld-sign.png", (long)_cardId];
    [self updateData];
    
    NSString *path = [self getSignImagePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:path contents:data attributes:nil];
}

- (NSString *)getSignImagePath
{
    return [self cacheImagePath:_signName];
}

- (UIImage *)cacheSign
{
    NSString *path = [self cacheImagePath:_signName];
    _signImage = [UIImage imageWithContentsOfFile:path];
    return _signImage;
}

#pragma mark 背景毛玻璃图片

- (void)saveBgImage:(UIImage *)image
{
    [self screenshot:image name:@"bg"];
}

- (UIImage *)getBgImage
{
    NSString *name = [NSString stringWithFormat:@"%ld-bg.png", (long)_cardId];
    NSString *path = [self cacheImagePath:name];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

#pragma mark 正反面截图

- (void)screenshotFront:(UIImage *)image
{
    _frontName = [self screenshot:image name:@"front"];
}

- (void)screenshotBack:(UIImage *)image
{
    _backName = [self screenshot:image name:@"back"];
}

- (void)screenshotUploadBack:(UIImage *)image
{
    [self screenshot:image name:@"back-upload"];
}

- (NSString *)screenshot:(UIImage *)image name:(NSString *)name
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1.0);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%ld-%@.png", (long)_cardId, name];
    
    NSString *path = [self cacheImagePath:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:path contents:data attributes:nil];
    
    NSLog(@"%@", path);
    
    return imageName;
}

- (NSString *)frontPath
{
    return [self cacheImagePath:_frontName];
}

- (NSString *)backPath
{
    return [self cacheImagePath:_backName];
}

- (NSString *)backUploadPath
{
    return [self cacheImagePath:[NSString stringWithFormat:@"%@-upload.png", [_backName stringByDeletingPathExtension]]];
}

@end
