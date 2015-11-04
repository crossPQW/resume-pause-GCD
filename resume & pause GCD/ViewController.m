//
//  ViewController.m
//  resume & pause GCD
//
//  Created by 黄少华 on 15/11/3.
//  Copyright © 2015年 黄少华. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    count = 0;
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [time setFireDate:[NSDate distantPast]];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    
    dispatch_queue_t queue1 = dispatch_queue_create("dispatchQueue1", 0);
    dispatch_queue_t queue2 = dispatch_queue_create("dispatchQueue2", 0);
    dispatch_group_t group  = dispatch_group_create();
    
    
    dispatch_async(queue1, ^{
        NSLog(@"任务1,队列1");
        
        sleep(5);
        
        NSLog(@"完成任务-----1");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"任务1,队列1");
        
        sleep(5);
        
        NSLog(@"完成任务-----2");
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"暂停中----1");
        dispatch_suspend(queue1);
    });
    
    dispatch_group_async(group, queue2, ^{
        NSLog(@"暂停中----2");
        dispatch_suspend(queue2);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"两个任务都完成了,再往下执行");
    dispatch_async(queue1, ^{
        NSLog(@"任务2,队列1");
        
        sleep(10);
        
        NSLog(@"完成了任务2,队列1");
    });
    dispatch_async(queue2, ^{
        NSLog(@"任务2,队列2");
        
        sleep(10);
        
        NSLog(@"完成了任务2,队列2");
    });
    
    NSLog(@"****************");
    
    dispatch_resume(queue1);
    dispatch_resume(queue2);
}

- (void)countDown
{
    count ++;
    NSLog(@"%d",count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
