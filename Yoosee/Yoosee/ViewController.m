//
//  ViewController.m
//  Yoosee
//
//  Created by zlqhjs on 16/9/15.
//  Copyright © 2016年 guojunyi. All rights reserved.
//

#import "ViewController.h"
#import "SearchDeviceInterface.h"

@interface ViewController ()

@property(nonatomic, strong) SearchDeviceInterface *ser;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ser = [[SearchDeviceInterface alloc] init];
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.ser releaseSearchJob];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.ser makeP2P];
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)dealloc
{
    [self.ser release];
    [super dealloc];
}


@end
