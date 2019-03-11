//
//  ViewController.m
//  NTGrade
//
//  Created by Jonny on 2019/3/11.
//  Copyright © 2019 sports8. All rights reserved.
//

#import "ViewController.h"

#import "GradeView.h"

@interface ViewController ()

@property (nonatomic, strong) GradeView * gradeView;

@end

@implementation ViewController

#pragma mark - 懒加载

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    [self setupBlock];
}

#pragma mark - Setup (UI搭建)

- (void)setupUI
{
    
    GradeView *gradeView = [[GradeView alloc] initWithFrame:CGRectMake(0, 0,  kScreenWidth, 400)];
    self.gradeView = gradeView;
    [self.view addSubview:gradeView];
}

#pragma mark - Block (回调)
- (void)setupBlock
{
    self.gradeView.gradeViewSelectBlock = ^(GradeInfo * _Nonnull gradeInfo) {
        NSLog(@"%@",gradeInfo.name);
    };
}
#pragma mark - Delegate (代理)

#pragma mark - Selector (事件 方法)




@end
