//
//  ViewController.m
//  05-主队列
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
    
    // 主队列，同步任务
    //[self mainSync];
    
    // 主队列，异步任务
    [self mainAsync];
    
    NSLog(@"end--->%@", [NSThread currentThread]);
}


// 主队列，异步任务
- (void)mainAsync {

    NSLog(@"%s", __func__);
    
    // 1. 创建一个主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
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
    
    // 3. 将三个任务添加到队列中
    dispatch_async(mainQueue, task1);
    dispatch_async(mainQueue, task2);
    dispatch_async(mainQueue, task3);
    
    
    /*
    因为是异步，所以end可以跳过三个任务
     因为都在主线程执行，所以三个任务顺序执行
     
     使用场景：
        当做了耗时操作回到主线程更新UI的时候，非他不可
     */
    
    /*
    打印结果：
     
      begin---><NSThread: 0x7febb0d05220>{number = 1, name = main}
      -[ViewController mainAsync]
      end---><NSThread: 0x7febb0d05220>{number = 1, name = main}
      task1---><NSThread: 0x7febb0d05220>{number = 1, name = main}
      task2---><NSThread: 0x7febb0d05220>{number = 1, name = main}
      task3---><NSThread: 0x7febb0d05220>{number = 1, name = main}
     */
}


// 主队列，同步任务
- (void)mainSync {
#warning 有问题，不能用，因为主队列只会在主线程有空闲的时候才会调度，然后里面的任务才会执行，造成死锁、死等，主线程卡死

    // 只是为了调试，说明我们来到了这个方法
    NSLog(@"%s", __func__);
    
    // 1. 创建一个主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
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
    
    // 3. 将任务添加到主队列中
    // 同步
    dispatch_sync(mainQueue, task1);
    dispatch_sync(mainQueue, task2);
    dispatch_sync(mainQueue, task3);
    
    
    /*
       begin---><NSThread: 0x7f93b9e01590>{number = 1, name = main}
      -[ViewController mainSync]
     */
}


@end
