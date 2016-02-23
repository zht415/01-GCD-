//
//  ViewController.m
//  10-定时源事件和子线程的运行循环
//
//  Created by 王鹏飞 on 16/1/24.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

NSInteger i = 0;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    // 在后台执行该方法
    [self performSelectorInBackground:@selector(subThreadRun) withObject:nil];
}

// 实现定时源方法
- (void)subThreadRun {
    
    NSLog(@"%s--->%@", __func__, [NSThread currentThread]);
    
    // 1. 创建计时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeEvent) userInfo:nil repeats:YES];
    
    
    /**
     NSDefaultRunLoopMode 当拖动的时候,它会停掉
     因为这种模式是互斥的
     
     forMode:UITrackingRunLoopMode 只有输入的时候,它才会去执行定时器任务
     
     // 2.将计时器添加到运行循环中，只有加入到运行循环中，才知道有这个操作
     
     NSRunLoopCommonModes 包含了前面两种
     */
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    // 3. 一定要有这一步，因为子线程运行循环默认不开放
    //下载,定时源事件,输入源事件,如果放在子线程里面,如果想要它执行任务,就必须开启子线程的运行循环
    CFRunLoopRun();
}

// 递增打印
- (void)timeEvent {

    NSLog(@"%@--->%ld", [NSThread currentThread], i++);
}


@end
