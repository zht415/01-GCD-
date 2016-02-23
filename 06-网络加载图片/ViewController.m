//
//  ViewController.m
//  06-网络加载图片
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
    
    [self downloadImage];
}

- (void)downloadImage {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1. 获取图片地址
        NSString *imgPath = @"http://g.hiphotos.baidu.com/image/pic/item/f31fbe096b63f624cd2991e98344ebf81b4ca3e0.jpg";
        
        // 2. 转化为路径
        NSURL *url = [NSURL URLWithString:imgPath];
        
        // 2. 转为NSData二进制类型数据
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 3. 转化为UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        // 4. 睡眠一段时间
        //[NSThread sleepForTimeInterval:3];
        
        // 5. 回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = image;
        });
    });
    
}


#warning 最常用的代码
- (void)download {

    /*
        如果在主线程中执行
     
        那么除了主队列，其他的串行、并发、全局都可以
     
        区主线程只有一个方法，就是主队列，异步
     */
    
    NSLog(@"begin--->%@", [NSThread currentThread]);
    
    // 异步模拟下载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"dLoading--->%@", [NSThread currentThread]);
        
        
        // 延迟
        [NSThread sleepForTimeInterval:5];
        
        // 回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"updateUI--->%@", [NSThread currentThread]);
        });
    });
    
    /*
     打印结果：
     
      begin---><NSThread: 0x7fec384041e0>{number = 1, name = main}
      dLoading---><NSThread: 0x7fec384041e0>{number = 1, name = main}
      updateUI---><NSThread: 0x7fec384041e0>{number = 1, name = main}
     */
}

@end
