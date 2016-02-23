//
//  ViewController.m
//  02-串行队列
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
    
    NSLog(@"touchBegin!--->%@", [NSThread currentThread]);
    
    // 串行队列，同步方法
    //[self serailSync];
    
    
    // 串行队列，异步方法
    [self serailAsync];
    
    NSLog(@"touchEnd!--->%@", [NSThread currentThread]);
}

// 串行队列，异步方法
- (void)serailAsync {
    
    // 1. 创建一个串行队列
    dispatch_queue_t serailQueue = dispatch_queue_create("com.apple", DISPATCH_QUEUE_SERIAL);
    
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
    
    // 3. 将创建的任务添加到队列中
    dispatch_async(serailQueue, task1);
    dispatch_async(serailQueue, task2);
    dispatch_async(serailQueue, task3);
    
    /* 
     因为是异步方法，所以新建子线程执行，这里只开辟一条子线程
     因为是串行，因此从上到下依次打印
        
     应用场景：
            耗时间，有顺序的场景
     
        1.登录--->2.付费--->3.才能看
     */
     
    /*
     打印结果：
     
    touchBegin!---><NSThread: 0x7fb191402480>{number = 1, name = main}
    touchEnd!---><NSThread: 0x7fb191402480>{number = 1, name = main}
    task1---><NSThread: 0x7fb19145f100>{number = 2, name = (null)}
    task2---><NSThread: 0x7fb19145f100>{number = 2, name = (null)}
    task3---><NSThread: 0x7fb19145f100>{number = 2, name = (null)}
     */
}

// 串行队列，同步方法
- (void)serailSync {

    // 1. 创建一个串行队列
    
    /*
     参数一：队列的标识符号，一般是公司名称倒写
     参数二：队列的类型
     
     DISPATCH_QUEUE_SERIAL 串行队列
     DISPATCH_QUEUE_CONCURRENT 并发队列
     */
    
    dispatch_queue_t serailQueue = dispatch_queue_create("com.apple", DISPATCH_QUEUE_SERIAL);
    
    
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
    
    // 3. 将创建好的三个任务添加到串行队列中，这个队列就开始调用我们的任务
    dispatch_sync(serailQueue, task1);
    dispatch_sync(serailQueue, task2);
    dispatch_sync(serailQueue, task3);
    
    /*
    因为是串行队列，因此在当前线程（主线程）中从上到下顺序执行 
     
     应用场景：很少使用
    
     */
    
    /*
     打印结果：
     
     touchBegin!---><NSThread: 0x7fbe72604d30>{number = 1, name = main}
     task1---><NSThread: 0x7fbe72604d30>{number = 1, name = main}
     task2---><NSThread: 0x7fbe72604d30>{number = 1, name = main}
     task3---><NSThread: 0x7fbe72604d30>{number = 1, name = main}
     touchEnd!---><NSThread: 0x7fbe72604d30>{number = 1, name = main}
     */
}

@end
