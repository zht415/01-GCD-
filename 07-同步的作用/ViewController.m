//
//  ViewController.m
//  07-同步的作用
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
    
    [self execLongTimeOperation];
}

/*
 同步的作用：保证任务执行的先后顺序
 
 先登陆，然后同时下载三部小视频
 */

- (void)execLongTimeOperation {
    
    // 这句代码有无均可
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        // 1. 首先登陆，同步执行，在当前线程中执行
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"login--->%@", [NSThread currentThread]);
        });
        
        // 2. 下载电影，并发执行
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"dloadA--->%@", [NSThread currentThread]);
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"dloadV--->%@", [NSThread currentThread]);
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"dloadI--->%@", [NSThread currentThread]);
        });
        
    });
    
    /*
     打印结果：
     
     login---><NSThread: 0x7fbd01e01c50>{number = 2, name = (null)}
     dloadA---><NSThread: 0x7fbd01e01c50>{number = 2, name = (null)}
     dloadV---><NSThread: 0x7fbd01d02580>{number = 3, name = (null)}
     dloadI---><NSThread: 0x7fbd01d13e50>{number = 4, name = (null)}
     */
}

@end
