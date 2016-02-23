//
//  ViewController.m
//  03-并发队列
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
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"bigin--->%@", [NSThread currentThread]);
    
    
    // 并发队列，同步执行
    [self conCurrentSync];
    
    // 并发队列，异步执行
    //[self conCurrentAsync];
    
    NSLog(@"end--->%@", [NSThread currentThread]);
}


// 并发队列，同步执行
- (void)conCurrentSync {

    // 1. 创建一个并发队列
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.apple", DISPATCH_QUEUE_CONCURRENT);
    
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
    dispatch_sync(conCurrentQueue, task1);
    dispatch_sync(conCurrentQueue, task2);
    dispatch_sync(conCurrentQueue, task3);
    
    /*
    因为是同步执行，所以都在当前线程（主线程）执行，不会开辟新的线程
     
     ******  遇到同步的时候，并发队列，还是依次执行，因此方法的优先级比队列的优先级高  ******
     
     应用场景：开发中几乎不用
     */
    
    /*
     打印结果：
     
      bigin---><NSThread: 0x7fabaac01c20>{number = 1, name = main}
      task1---><NSThread: 0x7fabaac01c20>{number = 1, name = main}
      task2---><NSThread: 0x7fabaac01c20>{number = 1, name = main}
      task3---><NSThread: 0x7fabaac01c20>{number = 1, name = main}
      end---><NSThread: 0x7fabaac01c20>{number = 1, name = main}
     */
}


// 并发队列，异步执行
- (void)conCurrentAsync {

    // 1. 创建一个并发队列
    /*
     参数一：const char *label              队列的标识符，一般是公司域名的倒写
     参数二：dispatch_queue_attr_t attr     队列的类型
     */
    
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.apple", DISPATCH_QUEUE_CONCURRENT);
    
    // 2. 创建三个block类型的任务(或者循环添加)
    void (^task1) () = ^(){
        NSLog(@"task1--->%@", [NSThread currentThread]);
    };
    
    void (^task2) () = ^(){
        NSLog(@"task2--->%@", [NSThread currentThread]);
    };
    
    void (^task3) () = ^(){
        NSLog(@"task3--->%@", [NSThread currentThread]);
    };
    
    // 3. 把这三个任务添加到并发队列中
    dispatch_async(conCurrentQueue, task1);
    dispatch_async(conCurrentQueue, task2);
    dispatch_async(conCurrentQueue, task3);

    
    /*
     无序
     
     因为是并发队列，所以任务都不在当前线程中执行，而是另外开辟子线程
     另外开辟子线程需要耗时间，因为是异步执行，因此end 可以跳过还未执行完毕的三个任务
     
     开N条子线程，是由底层可调度线程池来决定的，可调度线程池有一个可重用机制
     
     应用场景：
        当我们下载电影的时候，可以把片头、片尾、中间部分分开下载，等到都下载完毕后拼接一下就好了
     */
    
    
    /*
     打印结果：
     
      bigin---><NSThread: 0x7ff159e050c0>{number = 1, name = main}
      task1---><NSThread: 0x7ff159d01960>{number = 2, name = (null)}
      end---><NSThread: 0x7ff159e050c0>{number = 1, name = main}
      task3---><NSThread: 0x7ff159c03890>{number = 3, name = (null)}
      task2---><NSThread: 0x7ff159f1e4c0>{number = 4, name = (null)}
     */
}


@end
