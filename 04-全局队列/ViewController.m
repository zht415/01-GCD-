//
//  ViewController.m
//  04-全局队列
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    NSLog(@"begin--->%@", [NSThread currentThread]);
    
    // 全局队列，同步方法
    //[self globalSync];
    
    // 全局队列，异步方法
    [self globalAsync];
    
    NSLog(@"end--->%@", [NSThread currentThread]);
}



// 全局队列，异步方法
- (void)globalAsync {
    
    // 1. 创建一个异步方法
    
    /*
     参数一：ios7中表示优先级
            ios8中表示服务质量
     
            为了保证兼容ios7&ios8一般传入0
     
     参数二：未来使用，传入0
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    // 2. 创建三个任务
    void (^task1) () = ^(){
        NSLog(@"task1--->%@", [NSThread currentThread]);
    };
    
    void (^task2) () = ^(){
        NSLog(@"task2--->%@", [NSThread currentThread]);
    };
    
    void (^task3) () = ^(){
        NSLog(@"task3--->%@", [NSThread currentThread]);
    };
    
    // 3. 将任务添加到队列中
    // 异步的方法来执行
    dispatch_async(globalQueue, task1);
    dispatch_async(globalQueue, task2);
    dispatch_async(globalQueue, task3);
    
    /*
        无序
     
     因为是异步方法，因此开辟新的线程
     
    */
    
    /*
    打印结果：
     
      begin---><NSThread: 0x7fa90be012f0>{number = 1, name = main}
      end---><NSThread: 0x7fa90be012f0>{number = 1, name = main}
      task1---><NSThread: 0x7fa90bd03720>{number = 7, name = (null)}
      task3---><NSThread: 0x7fa90be018c0>{number = 6, name = (null)}
      task2---><NSThread: 0x7fa90bc16ec0>{number = 8, name = (null)}
     */
}


// 全局队列，同步方法
- (void)globalSync {
    
    // 1. 创建一个全局队列
    
    /*
     参数一：ios7中表示优先级
            ios8中表示服务质量
     
            为了保证兼容iOS7&iOS8一般传入0
     
     参数二：未来使用，传入0
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    // 2. 创建三个任务
    void (^task1) () = ^(){
        NSLog(@"task1--->%@", [NSThread currentThread]);
    };
    
    void (^task2) () = ^(){
        NSLog(@"task2--->%@", [NSThread currentThread]);
    };
    
    void (^task3) () = ^(){
        NSLog(@"task3--->%@", [NSThread currentThread]);
    };
    
    // 3. 将任务添加到队列中
    // 同步的方法去执行
    dispatch_sync(globalQueue, task1);
    dispatch_sync(globalQueue, task2);
    dispatch_sync(globalQueue, task3);

    
    /*
     因为是同步方法，因此不开辟线程，在当前线程（主线程）中顺序执行
     
     说明方法的优先级比队列的优先级高
     
     
     开发场景：开发中几乎不用
    */
    
    
    /*
     打印结果：
     
      begin---><NSThread: 0x7fe7f1708470>{number = 1, name = main}
      task1---><NSThread: 0x7fe7f1708470>{number = 1, name = main}
      task2---><NSThread: 0x7fe7f1708470>{number = 1, name = main}
      task3---><NSThread: 0x7fe7f1708470>{number = 1, name = main}
      end---><NSThread: 0x7fe7f1708470>{number = 1, name = main}
     */
}

@end
