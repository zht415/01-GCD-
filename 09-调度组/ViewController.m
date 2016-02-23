//
//  ViewController.m
//  09-调度组
//
//  Created by 王鹏飞 on 16/1/24.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/*
    应用场景：
        将三个视频完全下载完毕才能继续后续的操作，这里就需要用到调度组对任务进行监控
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self execGroupDispatch];
}


- (void)execGroupDispatch {

    NSLog(@"开始下载。。。--->%@", [NSThread currentThread]);
    
    // 1. 创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    
    // 2. 获取全局队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    // 3. 创建三个任务
    void (^task1) () = ^(){
        NSLog(@"正在下载片头--->%@", [NSThread currentThread]);
    };
    
#warning enter 和 leave 这两个函数在调度组内部已经封装好了
    /** 调度组实现原理 */
    dispatch_group_enter(group);
    
    void (^task2) () = ^(){
        NSLog(@"正在下载中间部分--->%@", [NSThread currentThread]);
        
        [NSThread sleepForTimeInterval:3];
        
        NSLog(@"中间部分已经下载完毕--->%@", [NSThread currentThread]);
        
        /** 如果没有这句话，调度组不会识别已经结束，就不会执行拼接的操作 */
        dispatch_group_leave(group);
    };
    
    void (^task3) () = ^(){
        NSLog(@"正在下载片尾--->%@", [NSThread currentThread]);
    };
    
    
    // 4. 将队列和任务添加到调度组里面
    /*
    任务一：需要加入的调度组
     任务二：执行代码的线程
     参数三：需要执行的代码
     */
    
    dispatch_group_async(group, globalQueue, task1);
    dispatch_group_async(group, globalQueue, task2);
    dispatch_group_async(group, globalQueue, task3);
    
    // 5. 监听调度组内时间是否完成
    /**
     参数1:组
     参数2:参数3在哪个线程里面执行
     参数3:组内完全下载完毕之后,需要执行的代码
     */
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"将下载的三段视频拼接中，马上播放！--->%@", [NSThread currentThread]);
    });
    
    /*
     快速添加到调度组：
        dispatch_group_async(group, q, ^{
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务 1 %@", [NSThread currentThread]);
     });
     */
    
    /*
     打印结果：
     
      开始下载。。。---><NSThread: 0x7fa10ad06610>{number = 1, name = main}
      正在下载中间部分---><NSThread: 0x7fa10ae0f710>{number = 3, name = (null)}
      正在下载片头---><NSThread: 0x7fa10ae15650>{number = 2, name = (null)}
      正在下载片尾---><NSThread: 0x7fa10ad251b0>{number = 4, name = (null)}
      将下载的三段视频拼接中，马上播放！---><NSThread: 0x7fa10ad251b0>{number = 4, name = (null)}
     */
}

@end
