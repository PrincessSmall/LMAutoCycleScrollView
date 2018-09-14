//
//  ViewController.m
//  LMAutoCycleScrollView
//
//  Created by 李敏 on 2018/8/16.
//  Copyright © 2018年 李敏. All rights reserved.
//

#import "ViewController.h"
#import "LMAutoCycleScrollView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


@interface ViewController ()<UIScrollViewDelegate>
{
    NSInteger _count;
}
@property (nonatomic ,strong)LMAutoCycleScrollView * autoCycleScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view, typically from a nib.
}
-(LMAutoCycleScrollView *)autoCycleScrollView{
    if (!_autoCycleScrollView) {
        _autoCycleScrollView = [[LMAutoCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 360)];
//        _autoCycleScrollView.backgroundColor = [UIColor greenColor];
         [self.autoCycleScrollView setImageCount:_count];
    }
    return _autoCycleScrollView;
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _count = 4;
    [self.view addSubview:self.autoCycleScrollView];
   
    [self.autoCycleScrollView startNSTimer];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.autoCycleScrollView endNStimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
