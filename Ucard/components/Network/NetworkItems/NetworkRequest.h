//
//  NetworkRequest.h
//  Ucard
//
//  Created by WuLeilei on 15/4/12.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "NetworkItemBase.h"

@interface NetworkRequest : NetworkItemBase

+ (instancetype)shareInstance;
- (void)signin:(NSString *)email password:(NSString *)password;
- (void)signup:(NSString *)email nickname:(NSString *)nickname password:(NSString *)password;
- (void)signupSNS:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname;
- (void)signupSNS:(NSString *)type uid:(NSString *)uid nickname:(NSString *)nickname email: (NSString *) email;
- (void)signinSNS:(NSString *)type uid:(NSString *)uid showLoading:(BOOL)showLoading;
- (void)checkSNS:(NSString *)type uid:(NSString *)uid;
- (void)checkSNS:(NSString *)type uid:(NSString *)uid andEmail: (NSString *) email;
- (void)forgetPassword:(NSString *)email;
- (void)getPrice:(NSString *)from to:(NSString *)to;
- (void)submitCard;
- (void)getUserInfo;
- (void)submitUserInfo:(UserInfoModel *)model;
- (void)submitHeader:(UIImage *)image;
- (void)submitOrder:(NSString *)postId paymentType:(NSString *)paymentType price:(NSString *)price productName:(NSString *)productName currency:(NSString *)currency originalCountry:(NSString *)originalCountry destinationCountry:(NSString *)destinationCountry;
- (void)changePassword:(NSString *)password;
- (void)getFrindCount;
- (void)searchCard:(NSString *)cardId;
- (void)finishPay:(NSString *)recordID swiftNumber:(NSString *)swiftNumber;
- (void)getSendList:(BOOL)showLoading;
- (void)getReceiveList:(BOOL)showLoading;
- (void)getPublicList;
- (void)confirmCard:(NSString *)cardId;
- (void)publicCard:(NSString *)cardId;
- (void)cancelPublicCard:(NSString *)cardId;
- (void)getSendCardDetail:(NSString *)cardId;
- (void)getReceiveCardDetail:(NSString *)cardId;
- (void)praiseCard:(NSString *)cardId;
- (void)commentCard:(NSString *)cardId comment:(NSString *)comment;
- (void)getCardComment:(NSString *)cardId;
- (void)getCommunityDetail:(NSString *)cardId;
- (void)getCardId;
- (void)updateCard;

- (void)getLocationList:(BOOL)showLoading;
@end
