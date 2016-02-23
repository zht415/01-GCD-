//
//  ViewController.m
//  01-GCD中同步和异步的写法
//
//  Created by 王鹏飞 on 16/1/24.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    /*
      touch--->begin
      touch--->end
      async----><NSThread: 0x7fbfc8518190>{number = 2, name = (null)}
     */
    
    
    NSLog(@"touch--->begin");
    // 异步任务
    
    
//    // 说明是另外开辟一条子线程进行异步任务，而不是在当前线层中进行，但是开线程会浪费时间
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"async---->%@", [NSThread currentThread]);
//    });
    [self sync];
    
    NSLog(@"touch--->end");
}


- (void)sync {

    // 同步任务
    /**
     参数一：队列
     参数二：任务
     */
    
    /*
      touch--->begin
      sync----><NSThread: 0x7f99c8c03650>{number = 1, name = main}
      touch--->end
     */
    
    NSLog(@"touch--->begin");
    
    // 说明在当前线程（这里是主线程）进行同步
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"sync---->%@", [NSThread currentThread]);
    });
    
    NSLog(@"touch--->end");
}

@end
