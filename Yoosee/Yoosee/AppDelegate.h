//
//  AppDelegate.h
//  Yoosee
//
//  Created by guojunyi on 14-3-20.
//  Copyright (c) 2014年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"
#import "Reachability.h"
#import "Contact.h"//重新调整监控画面
#import <AVFoundation/AVFoundation.h>

#define NET_WORK_CHANGE @"NET_WORK_CHANGE"
#define ALERT_TAG_ALARMING 0
#define ALERT_TAG_MONITOR 1
#define ALERT_TAG_APP_UPDATE 2

#define ap_address      "192.168.1.1"
#define ap_p2p_id       @"1"
#define ap_p2p_password @"0"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainController *mainController;
@property (strong, nonatomic) MainController *mainController_ap;
@property (strong, nonatomic) Contact *contact;//重新调整监控画面
@property (nonatomic) NetworkStatus networkStatus;
+(CGRect)getScreenSize:(BOOL)isNavigation isHorizontal:(BOOL)isHorizontal;
+(AppDelegate*)sharedDefault;

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *alarmContactId;
@property (strong, nonatomic) NSString *monitoredContactId;
//currentPushedContactId当前推送的ID，作用是，和下一个推送ID比较，若相等则不弹出推送框
@property (strong, nonatomic) NSString *currentPushedContactId;
//YES表示接收到推送，正在输入密码准备进行监控，此时不弹出任何推送
@property (nonatomic) BOOL isInputtingPwdToMonitor;
@property (nonatomic) long lastShowAlarmTimeInterval;
@property (nonatomic) BOOL isDoorBellAlarm;//在监控界面使用,区分门铃推送，其他推送
//YES表示正显示门铃推送界面，不弹出任何推送
@property (nonatomic) BOOL isShowingDoorBellAlarm;
//YES表示APP端从监控中再进入监控的方式，而且前提应该是只有监控、视频通话或呼叫状态下，才为YES
@property (nonatomic) BOOL isIntoMonitorFromMonitor;
@property (nonatomic) BOOL isMonitoring;//而且前提应该是只有监控、视频通话或呼叫状态下

+(NSString*)getAppVersion;
@property (nonatomic) BOOL isGoBack;
@property (nonatomic) BOOL isNotificationBeClicked;//YES表示点击系统消息推送通知，将显示系统消息表

@property (strong, nonatomic) AVAudioPlayer * alarmRingPlayer;

@property (nonatomic) int  dwApContactID;
@property (nonatomic) int  dwApDefenceStatus;

//停止播放报警铃声
-(void)stopToPlayAlarmRing;

@end
