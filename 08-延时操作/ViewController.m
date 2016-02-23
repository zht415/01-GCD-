//
//  ViewController.m
//  08-延时操作
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
    
    [self execDispatchAfter];
}


- (void)execDispatchAfter {

    NSLog(@"begin");
    
    /*
     参数一：延迟多少纳秒
     参数二：在哪个线程里调用
     参数三：执行延迟操作的代码
     
     
     dispatch_after 异步的
     
     应用场景：动画，钟摆，动画进行中停留一下继续进行
     */
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"finished--->%@", [NSThread currentThread]);
    });
    
    NSLog(@"----end-----%@", [NSThread currentThread]);
    
    /*
     打印结果证明是异步的：
     
     begin
     ----end-----<NSThread: 0x7f8192e04150>{number = 1, name = main}
     finished---><NSThread: 0x7f8192e04150>{number = 1, name = main}
     */
}

@end
