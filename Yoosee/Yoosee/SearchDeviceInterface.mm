//
//  SearchDeviceInterface.m
//  Yoosee
//
//  Created by zlqhjs on 16/9/11.
//  Copyright © 2016年 guojunyi. All rights reserved.
//

#import "SearchDeviceInterface.h"

#import "QRCodeNextController.h"
#import "TopBar.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "QRCodeGenerator.h"
#import "YProgressView.h"
#import "FListManager.h"
#import "CreateInitPasswordController.h"
#import "AddContactNextController.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#import "elian.h"
#import "WaitingPageView.h"
#import "QRCodeController.h"


@interface SearchDeviceInterface (){
    void *_context;
}
@property (nonatomic,copy) NSString *contactID;
@property (nonatomic,assign) NSInteger flag;//监控是否初始化过密码
@property (nonatomic,assign) NSInteger type;
@property (strong,nonatomic) NSMutableDictionary *addresses;

@property (nonatomic,copy) NSString *address;

@end

@implementation SearchDeviceInterface

- (void)makeP2P {
    //连接方式只用智能联机
    [self startSetWifiLoop];//给设备设置wifi
    [self deviceSetWifi];//直接调用，不用点击“听到了”按钮
    //该模块是否运行
    self.isRun = YES;
    //socket是否就绪
    self.isPrepared = NO;
    //是否还在获取设备
    self.isFinish = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(self.isRun){//不断广播获取设置好WIFI的设备
            if(!self.isPrepared){
                [self prepareSocket];
            }
            usleep(1000000);
        }
    });
}

- (id)fetchSSIDInfo//获取wifi信息
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
        [info release];
    }
    [ifs release];
    return [info autorelease];
}

#pragma mark - 空中发包，给设备设置wifi
- (void)startSetWifiLoop {
    NSDictionary *ifs = [self fetchSSIDInfo];
    NSString *ssidPre = [ifs objectForKey:@"SSID"];
    while (!ssidPre) {
        ssidPre = [ifs objectForKey:@"SSID"];
    }
    
    //ssid
    const char *ssid = [ssidPre cStringUsingEncoding:NSUTF8StringEncoding];
    //authmode
    int authmode = 9;//delete
    //pwd
    const char *password = [@"fengwukeji" cStringUsingEncoding:NSUTF8StringEncoding];//NSASCIIStringEncoding
    //target
    unsigned char target[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
    
    
    _context = elianNew(NULL, 0, target, ELIAN_SEND_V1 | ELIAN_SEND_V4);
    elianPut(_context, TYPE_ID_AM, (char *)&authmode, 1);//delete
    elianPut(_context, TYPE_ID_SSID, (char *)ssid, strlen(ssid));
    elianPut(_context, TYPE_ID_PWD, (char *)password, strlen(password));
    
    elianStart(_context);
}


- (void)releaseSearchJob {
    if (1){//startSetWifiLoop
        if (_context){
            elianStop(_context);
            elianDestroy(_context);
            _context = NULL;
        }
    }
    
    self.isWaiting = NO;//isWaiting is NO
    self.isFinish = YES;
    self.isRun = NO;
    if(self.socket){
        [self.socket close];
        self.socket=nil;
    }
}

-(BOOL)prepareSocket{
    GCDAsyncUdpSocket *socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    NSError *error = nil;
    
    
    if (![socket bindToPort:9988 error:&error])
    {
        NSLog(@"Error binding: %@", [error localizedDescription]);
        return NO;
    }
    if (![socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", [error localizedDescription]);
        return NO;
    }
    
    if (![socket enableBroadcast:YES error:&error])
    {
        NSLog(@"Error enableBroadcast: %@", [error localizedDescription]);
        return NO;
    }
    
    self.socket = socket;
    self.isPrepared = YES;
    return YES;
}
#pragma mark - 使用90秒来进行空中发包，给设备设置wifi
- (void)deviceSetWifi {
    
    self.isWaiting = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int index = 0;
        while(self.isWaiting){
            DLog(@"%i",index);
            index++;
            if (1){//startSetWifiLoop
                if (index >= 21 && index <= 30)
                {
                    if (index == 21)
                    {
                        elianStop(_context);
                    }
                }
                else if (index >= 51 && index <= 60)
                {
                    if (index == 51)
                    {
                        elianStop(_context);
                    }
                }
                else if (index >= 81)
                {
                    if (index == 81)
                    {
                        elianStop(_context);
                    }
                }
                else
                {
                    if (index==31 || index==61)
                    {
                        elianStart(_context);
                    }
                }
                if(index>=90)
                {//90
                    break;
                }
            }
            else
            {
                if(index>=60)
                {//60
                    break;
                }
            }
            sleep(1.0);
        }
        
        //此处试着增加一些bool值来控制界面上的类似indicator的显示周期
        if(!self.isFinish){
            if (1){//startSetWifiLoop
                if (_context){
                    elianStop(_context);
                    elianDestroy(_context);
                    _context = NULL;
                }//设置WIFI失败，停止
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.isWaiting = NO;//isWaiting is NO
            });
            
        }
    });
    
}

#pragma mark - GCDAsyncUdpSocket
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"did send");
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"error %@", error);
}

#pragma mark 搜索设备
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    if (data) {
        Byte receiveBuffer[1024];
        [data getBytes:receiveBuffer length:1024];
        
        if(receiveBuffer[0]==1){
            NSString *host = nil;
            uint16_t port = 0;
            [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];//打断点，查看adress
            
            int contactId = *(int*)(&receiveBuffer[16]);
            int type = *(int*)(&receiveBuffer[20]);
            int flag = *(int*)(&receiveBuffer[24]);
            //这些参数要传出使用
            self.contactID = [NSString stringWithFormat:@"%d",contactId];
            self.type = type;
            self.flag = flag;
            [self.addresses setObject:host forKey:[NSString stringWithFormat:@"%i",contactId]];
            NSLog(@"%d,%d",type,flag);
            
            if(self.isWaiting){
                self.isWaiting = NO;//isWaiting is NO
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isFinish = YES;
                    if (_context){
                        elianStop(_context);
                        elianDestroy(_context);
                        _context = NULL;
                    }//设置WIFI成功，停止
                });
                
            }
        }
    }
}

//获取到设备之后，构建一个contact对象，insert到FlistManager中

-(void)dealloc{
    [self.uuidString release];
    [self.wifiPwd release];
    [self.smartKeyPromptView release];
    [self.qrcodeImageView release];
    [self.addresses release];
    [self.promptButton release];//set wifi to add device by qr
    [self.topBar release];//set wifi to add device by qr
    [super dealloc];    
}

@end
