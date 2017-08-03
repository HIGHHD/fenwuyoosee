//
//  UserInterface.m
//  Yoosee
//
//  Created by zlqhjs on 16/9/16.
//  Copyright © 2016年 guojunyi. All rights reserved.
//

#import "UserInterface.h"
#import "LoginController.h"
#import "Constants.h"
#import "Utils.h"
#import "Toast+UIView.h"
#import "NetManager.h"
#import "MBProgressHUD.h"
#import "MainController.h"
#import "LoginResult.h"
#import "UDManager.h"
#import "AppDelegate.h"
#import "TopBar.h"
#import "AccountResult.h"
#import "Toast+UIView.h"
#import "ChooseCountryController.h"
#import "EmailRegisterController.h"
#import "BindPhoneController.h"
#import "CheckNewMessageResult.h"
#import "GetContactMessageResult.h"
#import "Message.h"
#import "MessageDAO.h"
#import "FListManager.h"
#import "ContactDAO.h"
#import "NewRegisterController.h"

@interface UserInterface()

@end

@implementation UserInterface

- (void)onForgetPassword {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.cloudlinks.cn/pw/"]];
}


#pragma mark - 点击登录按钮
- (void)loginWithParam:(NSDictionary *)param {
    //loginType,0为邮箱登录,1为手机号登录
    int loginType = [[param objectForKey:@"loginType"] intValue];
    NSString *username = [param objectForKey:@"username"];
    NSString *password = [param objectForKey:@"password"];
    //token是Yoosee的注册APNS的token，这里暂写nil
    NSString *token = [param objectForKey:@"token"];
    
    //后续如若有记住密码等操作，该参数就是在此方法中处理还是用weblocal？
    if(loginType==0){
        [[NetManager sharedManager] loginWithUserName:username password:password token:token callBack:^(id result){
            
            LoginResult *loginResult = (LoginResult*)result;

            switch(loginResult.error_code){
                case NET_RET_LOGIN_SUCCESS:
                {
                    DLog(@"contactId:%@",loginResult.contactId);
                    DLog(@"Email:%@",loginResult.email);
                    DLog(@"Phone:%@",loginResult.phone);
                    DLog(@"CountryCode:%@",loginResult.countryCode);
                    [UDManager setIsLogin:YES];
                    [UDManager setLoginInfo:loginResult];
                    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"USER_NAME"];
                    [[NSUserDefaults standardUserDefaults] setInteger:loginType forKey:@"LOGIN_TYPE"];
                    
                    [[NetManager sharedManager] getAccountInfo:loginResult.contactId sessionId:loginResult.sessionId callBack:^(id JSON){
                        AccountResult *accountResult = (AccountResult*)JSON;
                        loginResult.email = accountResult.email;
                        loginResult.phone = accountResult.phone;
                        loginResult.countryCode = accountResult.countryCode;
                        [UDManager setLoginInfo:loginResult];
                    }];
                    
                    
                }
                    break;
                case NET_RET_LOGIN_USER_UNEXIST:
                {
                    DLog(@"user_unexist,%@",NSLocalizedString(@"user_unexist", nil));
                }
                    break;
                case NET_RET_LOGIN_PWD_ERROR:
                {
                    DLog(@"user_unexist,%@",NSLocalizedString(@"password_error", nil));
                }
                    break;
                case NET_RET_LOGIN_EMAIL_FORMAT_ERROR:
                {
                    DLog(@"user_unexist,%@",NSLocalizedString(@"login_failure", nil));
                }
                    break;
                    
                default:
                {
                    DLog(@"user_unexist,%@",[NSString stringWithFormat:@"%@:%i",NSLocalizedString(@"login_failure", nil),loginResult.error_code]);
                }
                    break;
            }
            
        }];
        
    }else{
        //yoosee做了本地化处理，传入的参数要加国家编号，例+86-13333333333
        DLog(@"%@",username);
        NSRange rangeOfPhone = [username rangeOfString:@"-"];
        NSString *phone = [username substringFromIndex:rangeOfPhone.location + 1];
        
        [[NetManager sharedManager] loginWithUserName:username password:password token:token callBack:^(id result){
            
            LoginResult *loginResult = (LoginResult* )result;
            
            switch(loginResult.error_code){
                case NET_RET_LOGIN_SUCCESS:
                {
                    [UDManager setIsLogin:YES];
                    [UDManager setLoginInfo:loginResult];
                    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"PHONE_NUMBER"];
                    [[NSUserDefaults standardUserDefaults] setInteger:loginType forKey:@"LOGIN_TYPE"];
                    NSLog(@"NET_RET_LOGIN_SUCCESS");
                    NSLog(@"%@",loginResult);
                }
                    break;
                case NET_RET_LOGIN_USER_UNEXIST:
                {
                    DLog(@"user_unexist,%@",NSLocalizedString(@"user_unexist", nil));
                     NSLog(@"%@",loginResult);
                }
                    break;
                case NET_RET_LOGIN_PWD_ERROR:
                {
                    DLog(@"user_unexist,%@",NSLocalizedString(@"password_error", nil));
                     NSLog(@"%@",NSStringFromClass([loginResult class]));
                }
                    break;
                case NET_RET_UNKNOWN_ERROR:
                {
                    DLog(@"user_unexist,%@",NSLocalizedString(@"login_failure", nil));
                    NSLog(@"%@",loginResult);
                }
                    break;
                    
                default:
                {
                    DLog(@"user_unexist,%@",[NSString stringWithFormat:@"%@:%i",NSLocalizedString(@"login_failure", nil),loginResult.error_code]);
                     NSLog(@"%@",loginResult);
                }
                    break;
            }
            
        }];
    }
    
}

@end
