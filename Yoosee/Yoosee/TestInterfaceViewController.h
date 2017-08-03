//
//  TestInterfaceViewController.h
//  Yoosee
//
//  Created by zlqhjs on 16/9/24.
//  Copyright © 2016年 guojunyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "P2PClient.h"
#import "AutoTabBarController.h"
#import "Contact.h"//重新调整监控画面

@interface TestInterfaceViewController : AutoTabBarController<P2PClientDelegate>
@property (nonatomic) BOOL isShowP2PView;
@property (nonatomic) BOOL isShowingMonitorController;
@property (nonatomic,strong) NSString * contactName;
@property (nonatomic,strong) Contact * contact;//重新调整监控画面

-(void)dismissP2PView;
-(void)dismissP2PView:(void (^)())callBack;
@end
