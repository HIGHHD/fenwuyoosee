//
//  SearchDeviceInterface.h
//  Yoosee
//
//  Created by zlqhjs on 16/9/11.
//  Copyright © 2016年 guojunyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QRCodeController.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "Constants.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Toast+UIView.h"
#import "QRCodeGenerator.h"
#import "QRCodeNextController.h"
#import "MainController.h"
#import "ParamDao.h"
#import "ConnectFailurePromptView.h"
#import "QRCodeSetWIFINextController.h"//set wifi to add device by qr
#import "Utils.h"

#import "QRCodeGuardFirst.h"
#import "QRCodeGuardSecond.h"
#import "TabView.h"
#import "ConnectFailurePromptView.h"

//手动添加已联网设备AddContactNextController.h，智能添加以及二维码扫描在QRCodeNextController.h。

@interface SearchDeviceInterface : NSObject

@property (nonatomic,strong) NSString *uuidString;
@property (nonatomic,strong) NSString *wifiPwd;
@property (nonatomic,strong) UIImageView *qrcodeImageView;
@property (nonatomic,strong) UIView *smartKeyPromptView;

@property (nonatomic) BOOL isNotFirst;
@property (nonatomic) BOOL isWaiting;//YES表示发包设置wifi后，在等待局域网添加设备
@property (nonatomic) BOOL isFinish;
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
@property (assign) BOOL isRun;
@property (nonatomic) BOOL isShowSuccessAlert;
@property (assign) BOOL isPrepared;
@property (nonatomic) int conectType;        //1-二维码扫描 0-智能联机
@property (strong, nonatomic) QRCodeController *qrCodeController;//set wifi to add device by qr
@property (nonatomic,strong) UIButton *promptButton;//set wifi to add device by qr
@property (strong, nonatomic) TopBar *topBar;//set wifi to add device by qr

- (void)makeP2P;
- (void)releaseSearchJob;

@end
