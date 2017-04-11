//
//  ViewController.m
//  GCD
//
//  Created by jinstar520 on 2017/4/10.
//  Copyright © 2017年 jinstar520. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController {
    NSArray *_dataSource;
    NSArray *_sectionTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *baseSource = @[@"并发队列 + 同步执行", @"并发队列 + 异步执行", @"串行队列 + 同步执行", @"串行队列 + 异步执行", @"主队列 + 同步执行", @"主队列 + 异步执行", @"栅栏方法", @"延时执行方法", @"一次性执行", @"快速迭代方法", @"dispatch_set_target_queue"];
    NSArray *groupSource = @[@"队列组：异步任务的同步1", @"队列组：异步任务的同步2", @"队列组：异步任务的同步3", @"队列组：串行任务的同步"];
    NSArray *semaphoreSource = @[@"", @"并发任务数量控制"];
    NSArray *blockSource = @[@"创建dispatch_block", @"dispatch_block_wait：可以根据dispatch block来设置等待时间，参数DISPATCH_TIME_FOREVER会一直等待block结束", @"dispatch_block_notify", @"dispatch_block_cancel"];
    _dataSource = @[baseSource, groupSource, semaphoreSource, blockSource];
    _sectionTitles = @[@"基础使用方法", @"队列组group", @"semaphore信号量", @"dispatch_block"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.sectionHeaderHeight = 60;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", (int)(indexPath.row+1), _dataSource[indexPath.section][indexPath.row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self syncConcurrent];
                    break;
                case 1:
                    [self asyncConcurrent];
                    break;
                case 2:
                    [self syncSerial];
                    break;
                case 3:
                    [self asyncSerial];
                    break;
                case 4:
                    [self syncMain];
                    break;
                case 5:
                    [self asyncMain];
                    break;
                case 6:
                    [self barrier];
                    break;
                case 7:
                    [self after];
                    break;
                case 8:
                    [self once];
                    break;
                case 9:
                    [self apply];
                    break;
                case 10:
                    [self set_target_queue];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self asyncConcurrentGroupAndMainQueueNotify1];
                    break;
                case 1:
                    [self asyncConcurrentGroupAndMainQueueNotify2];
                    break;
                case 2:
                    [self asyncConcurrentGroupAndMainQueueNotify3];
                    break;
                case 3:
                    [self asyncSerialGroupNotify];
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    
                    break;
                case 1:
                    [self concurrentCountControl];
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    [self createDispatchBlock];
                    break;
                case 1:
                    [self dispatchBlockWait];
                    break;
                case 2:
                    [self dispatchBlockNotify];
                    break;
                case 3:
                    [self dispatchBlockCancel];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 并发队列 + 同步执行
- (void)syncConcurrent {
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"1--------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"2--------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"3--------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

#pragma mark - 并发队列 + 异步执行
- (void)asyncConcurrent {
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"1--------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"2--------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"3--------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

#pragma mark - 串行队列 + 同步执行
- (void)syncSerial {
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("syncSerial.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
}

#pragma mark - 串行队列 + 异步执行
- (void)asyncSerial {
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("asyncSerial.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
}

#pragma mark - 主队列 + 同步执行
- (void)syncMain {
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain---end");
}

#pragma mark - 主队列 + 异步执行
- (void)asyncMain {
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain---end");
}

#pragma mark - 栅栏方法
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("barrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"----1-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----2-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----3-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----4-----%@", [NSThread currentThread]);
    });
}

#pragma mark - 延时执行方法
- (void)after {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2秒后异步执行这里的代码...
        NSLog(@"run-----");
    });
}

#pragma mark - 一次性代码
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

#pragma mark - 快速迭代方法
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd------%@",index, [NSThread currentThread]);
    });
}

#pragma mark - dispatch_set_target_queue
- (void)set_target_queue {
    dispatch_queue_t targetQueue = dispatch_queue_create("targetQueue", DISPATCH_QUEUE_SERIAL);//目标队列
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);//串行队列
    dispatch_queue_t queue2 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);//并发队列
    
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    
    dispatch_async(queue2, ^{
        NSLog(@"job3 in");
        sleep(2);
        NSLog(@"job3 out");
    });
    dispatch_async(queue2, ^{
        NSLog(@"job2 in");
        sleep(1);
        NSLog(@"job2 out");
    });
    dispatch_async(queue1, ^{
        NSLog(@"job1 in");
        sleep(3);
        NSLog(@"job1 out");
    });
}

#pragma mark - 设置队列优先级
- (void)setQueuePriority1 {
    dispatch_queue_attr_t queue_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, DISPATCH_QUEUE_PRIORITY_LOW);
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", queue_attr);
}

- (void)setQueuePriority2 {
    dispatch_queue_t target_queue = dispatch_queue_create("target_queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_set_target_queue(queue, target_queue);
}

#pragma mark - 队列组：异步任务的同步1
- (void)asyncConcurrentGroupAndMainQueueNotify1 {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"主线程执行");
    });
}

#pragma mark - 队列组：异步任务的同步2
- (void)asyncConcurrentGroupAndMainQueueNotify2 {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(concurrentQueue, ^{
        sleep(3);
        NSLog(@"任务一完成------%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(concurrentQueue, ^{
        sleep(4);
        NSLog(@"任务二完成------%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"主线程执行");
    });
}

#pragma mark - 队列组：异步任务的同步3
- (void)asyncConcurrentGroupAndMainQueueNotify3 {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(concurrentQueue, ^{
        sleep(3);
        NSLog(@"任务一完成------%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(concurrentQueue, ^{
        sleep(4);
        NSLog(@"任务二完成------%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    // 会卡住当前线程
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"notify：任务都完成了\n");
    });
}

#pragma mark - 队列组：串行任务的同步
- (void)asyncSerialGroupNotify {
    dispatch_queue_t queue = dispatch_queue_create("serial.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"任务一完成------%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        sleep(4);
        NSLog(@"任务二完成------%@",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, globalQueue, ^{
        NSLog(@"notify：任务都完成了\n");
    });
}

- (void)concurrentControl {
    dispatch_semaphore_t sema = dispatch_semaphore_create(10);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"do some job");
        sleep(1);
        NSLog(@"increase the semaphore");
        dispatch_semaphore_signal(sema); //信号值加1
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);//等待直到信号值大于等1
    NSLog(@"go on");
}

#pragma mark - 并发任务数量控制
- (void)concurrentCountControl {
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(1);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"go on");
}

- (void)createDispatchBlock {
    //normal way
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.concurrentqueue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t block = dispatch_block_create(0, ^{
        NSLog(@"run block");
    });
    dispatch_async(concurrentQueue, block);
    
    //QOS way
    dispatch_block_t qosBlock = dispatch_block_create_with_qos_class(0, QOS_CLASS_USER_INITIATED, -1, ^{
        NSLog(@"run qos block");
    });
    dispatch_async(concurrentQueue, qosBlock);
}

- (void)dispatchBlockWait {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t block = dispatch_block_create(0, ^{
        NSLog(@"star");
        [NSThread sleepForTimeInterval:5.f];
        NSLog(@"end");
    });
    dispatch_async(serialQueue, block);
    //设置DISPATCH_TIME_FOREVER会一直等到前面任务都完成
    dispatch_block_wait(block, DISPATCH_TIME_FOREVER);
    NSLog(@"ok, now can go on");
}

- (void)dispatchBlockNotify {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t firstBlock = dispatch_block_create(0, ^{
        NSLog(@"first block start");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"first block end");
    });
    dispatch_async(concurrentQueue, firstBlock);
    dispatch_block_t secondBlock = dispatch_block_create(0, ^{
        NSLog(@"second block run");
    });
    //first block执行完才在serial queue中执行second block
    dispatch_block_notify(firstBlock, concurrentQueue, secondBlock);
}

- (void)dispatchBlockCancel {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t __block firstBlock = dispatch_block_create(0, ^{
        NSLog(@"first block start");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"first block end");
    });
    dispatch_block_t secondBlock = dispatch_block_create(0, ^{
        NSLog(@"second block run");
    });
    dispatch_async(serialQueue, firstBlock);
    dispatch_async(serialQueue, secondBlock);
    //取消secondBlock
    dispatch_block_cancel(secondBlock);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
























