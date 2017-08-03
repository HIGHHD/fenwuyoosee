//
//  LoginResult.h
//  Yoosee
//
//  Created by guojunyi on 14-3-24.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginResult : NSObject<NSCoding>
//两个rcode是不随着sessionID的改变而改变的，与contactID是一个性质的。
@property (strong, nonatomic) NSString* contactId;//可以用来登录的ID--04137144
@property (strong, nonatomic) NSString* rCode1;//832008282
@property (strong, nonatomic) NSString* rCode2;//这两个rcode在P2PClient中被连接时用到了--1163045012
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* sessionId;//
@property (strong, nonatomic) NSString* countryCode;//手机号的国家码
@property (nonatomic) int error_code;//登录后的结果
@end
