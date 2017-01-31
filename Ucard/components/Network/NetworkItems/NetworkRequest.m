//
//  NetworkRequest.m
//  Ucard
//
//  Created by WuLeilei on 15/4/12.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "NetworkRequest.h"

@interface NetworkRequest ()
{
    NSInteger _tag;
}
@end

@implementation NetworkRequest

+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)signin:(NSString *)email password:(NSString *)password
{
    _showLoading = NO;
    _path = @"signin.php";
    _params = @{@"email": email,
                @"password": password};
    [self startPost];
}

- (void)signup:(NSString *)email nickname:(NSString *)nickname password:(NSString *)password
{
    _showLoading = NO;
    _path = @"register.php";
    _params = @{@"email": email,
                @"nickname": nickname,
                @"password": password};
    [self startPost];
}

- (void)signupSNS:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname
{
    _showLoading = NO;
    _path = @"third-party-register.php";
    _params = @{@"thirdPartyUid": uid,
                @"nickname": nickname,
                @"registerType": type};
    [self startPost];
}
- (void)signupSNS:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname email: (NSString *) email
{
    _showLoading = NO;
    _path = @"third-party-register.php";
    _params = @{@"thirdPartyUid": uid,
                @"nickname": nickname,
                @"registerType": type
                ,@"email": email
                };
    [self startPost];
}
- (void)signinSNS:(NSString *)type uid:(NSString *)uid showLoading:(BOOL)showLoading
{
    _showLoading = showLoading;
    _path = @"third-party-login.php";
    _params = @{@"thirdPartyUid": uid,
                @"registerType": type};
    [self startPost];
}

- (void)checkSNS:(NSString *)type uid:(NSString *)uid
{
    _flag = NWFlagNotShowError;
    _path = @"third-party-check.php";
    _params = @{@"thirdPartyUid": uid,
                @"registerType": type};
    [self startPost];
}
- (void)checkSNS:(NSString *)type uid:(NSString *)uid andEmail: (NSString *) email
{
    _flag = NWFlagNotShowError;
    _path = @"third-party-check.php";
    _params = @{@"thirdPartyUid": uid,
                @"registerType": type
//                ,@"email": email
                };
    [self startPost];
}
- (void)forgetPassword:(NSString *)email
{
    _showLoading = NO;
    _path = @"find-password.php";
    _params = @{@"email": email};
    [self startPost];
}

- (void)getPrice:(NSString *)from to:(NSString *)to
{
    _path = @"get-price.php";
    _params = @{@"originalCountry": from, @"destinationCountry": to};
    [self startPost];
}

- (void)submitCard
{
    _path = @"upload-postcard.php";
    _params = @{@"uuid": [Singleton shareInstance].uid,
                @"postcardGreetings": [Singleton shareInstance].cardModel.text,
                @"houseNumber": [Singleton shareInstance].cardModel.building,
                @"streetNumber": [Singleton shareInstance].cardModel.street,
                @"city": [Singleton shareInstance].cardModel.city,
                @"county": [Singleton shareInstance].cardModel.province,
                @"postcode": [Singleton shareInstance].cardModel.zip,
                @"country": [Singleton shareInstance].cardModel.country,
                };
    self.directFiles = @[@{@"name": @"postcardFront", @"path": [[Singleton shareInstance].cardModel frontPath]},
                         @{@"name": @"postcardBack", @"path": [[Singleton shareInstance].cardModel backUploadPath]}];
    [self startPost];
}

- (void) getUserInfo
{
    _path = @"get-details.php";
    _params = @{@"uuid": [Singleton shareInstance].uid};
    [self startPost];
}

- (void)submitUserInfo:(UserInfoModel *)model
{
    _path = @"add-details.php";
    _params = @{@"uuid": [Singleton shareInstance].uid,
                @"firstName": model.first_name,
                @"nickname": model.nickname,
                @"middleName": model.middle_name,
                @"lastName": model.last_name,
                @"houseNumber": model.house_number,
                @"street": model.street,
                @"city": model.city,
                @"county": model.county,
                @"postcode": model.postcode ? model.postcode : @"",
                @"registerType": model.register_type,
                @"thirdPartyUid": model.third_party_uid,
                @"dateOfBirth": model.date_of_birth,
                @"sex": model.sex == 0 ? @"girl" : @"boy",
                @"email": model.email,
                @"country": model.country};
    [self startPost];
}

- (void)submitHeader:(UIImage *)image
{
    _path = @"add-details-photo.php";
    _params = @{@"uuid": [Singleton shareInstance].uid};
    _files = @[@{@"name": @"imageToUpload", @"image": image}];
    [self startPost];
}

- (void)submitOrder:(NSString *)postId paymentType:(NSString *)paymentType price:(NSString *)price productName:(NSString *)productName currency:(NSString *)currency originalCountry:(NSString *)originalCountry destinationCountry:(NSString *)destinationCountry
{
    _path = @"generate-record.php";
    _params = @{@"uuid": [Singleton shareInstance].uid,
                @"postId": postId,
                @"paymentType": paymentType,
                @"price": price,
                @"productName": productName,
                @"currency": currency,
                @"originalCountry": originalCountry,
                @"destinationCountry": destinationCountry};
    [self startPost];
}

- (void)changePassword:(NSString *)password
{
    _path = @"change-password.php";
    _params = @{@"uuid": [Singleton shareInstance].uid,
                @"password": password};
    [self startPost];
}

- (void)getFrindCount
{
    _path = @"get-friend-number.php";
    _params = @{@"uuid": [Singleton shareInstance].uid};
    [self startPost];
}

- (void)searchCard:(NSString *)cardId
{
    _path = @"search-postcard.php";
    _params = @{@"uuid": [Singleton shareInstance].uid,
                @"postcardID": cardId};
    [self startPost];
}

- (void)finishPay:(NSString *)recordID swiftNumber:(NSString *)swiftNumber
{
    _path = @"finish-record.php";
    _params = @{@"recordID": recordID,
                @"swiftNumber": swiftNumber};
    [self startPost];
}

- (void)getSendList:(BOOL)showLoading
{
    _showLoading = showLoading;
    _showError = NO;
    _path = @"postcard-sending-list.php";
    _params = @{@"uuid": [Singleton shareInstance].uid};
    [self startPost];
}

- (void)getReceiveList:(BOOL)showLoading
{
    _showLoading = showLoading;
    _showError = NO;
    _path = @"postcard-receiving-list.php";
    _params = @{@"uuid": [Singleton shareInstance].uid};
    [self startPost];
}
- (void)getLocationList:(BOOL)showLoading
{
    _showLoading = showLoading;
    _showError = NO;
    _path = @"Addbdkdakd";
    _params = @{};
    [self startGetLocation];
}

- (void)getPublicList
{
    _showError = NO;
    _path = @"postcard-community-list.php";
    [self startGet];
}

- (void)confirmCard:(NSString *)cardId
{
    _path = @"confirm-postcard.php";
    _params = @{@"uuid": [Singleton shareInstance].uid,
                @"postcardConfirmCode": cardId};
    [self startPost];
}

- (void)publicCard:(NSString *)cardId
{
    _tag = 110;
    _path = @"public-postcard.php";
    _params = @{@"postcardID": cardId};
    [self startPost];
}

- (void)cancelPublicCard:(NSString *)cardId
{
    _tag = 110;
    _path = @"cancel-public-postcard.php";
    _params = @{@"postcardID": cardId};
    [self startPost];
}

- (void)getSendCardDetail:(NSString *)cardId
{
    _path = @"sent-postcard-details.php";
    _params = @{@"postcardID": cardId};
    [self startPost];
}

- (void)getReceiveCardDetail:(NSString *)cardId
{
    _path = @"received-postcard-details.php";
    _params = @{@"postcardID": cardId};
    [self startPost];
}

- (void)praiseCard:(NSString *)cardId
{
    _path = @"post-like.php";
    _params = @{@"postcardID": cardId};
    [self startPost];
}

- (void)commentCard:(NSString *)cardId comment:(NSString *)comment
{
    _path = @"make-comment.php";
    _params = @{@"uuid": [Singleton shareInstance].uid,
                @"postcardID": cardId,
                @"comment": comment};
    [self startPost];
}

- (void)getCommunityDetail:(NSString *)cardId
{
    _path = @"postcard-community-details.php";
    _params = @{@"postcardId": cardId};
    [self startPost];
}

- (void)getCardComment:(NSString *)cardId
{
    _path = @"comment-list.php";
    _params = @{@"postcardId": cardId};
    [self startPost];
}

- (void)getCardId
{
    _path = @"get-postcard-id.php";
    _params = @{@"uuid": [Singleton shareInstance].uid};
    [self startPost];
}

- (void)updateCard
{
    NSLog(@"%@", [Singleton shareInstance].cardModel);
    _showLoading = NO;
    _path = @"update-postcard.php";
    _params = @{@"postcardId": [Singleton shareInstance].cardModel.remoteCardId,
                @"uuid": [Singleton shareInstance].uid,
                @"postcardGreetings": [Singleton shareInstance].cardModel.text,
                @"houseNumber": [Singleton shareInstance].cardModel.building,
                @"streetNumber": [Singleton shareInstance].cardModel.street,
                @"city": [Singleton shareInstance].cardModel.city,
                @"county": [Singleton shareInstance].cardModel.province,
                @"postcode": [Singleton shareInstance].cardModel.zip,
                @"country": [Singleton shareInstance].cardModel.country,
                };
    self.directFiles = @[@{@"name": @"postcardFront", @"path": [[Singleton shareInstance].cardModel frontPath]},
                         @{@"name": @"postcardBack", @"path": [[Singleton shareInstance].cardModel backUploadPath]}];
    [self startPost];
}

- (void)privateRequestCompleted:(id)result
{
    if (_tag == 110) { // (取消)公开
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCommunityNotification" object:nil];
    }
    [super privateRequestCompleted:result];
}

@end
