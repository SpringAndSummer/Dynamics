//
//  SnapViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//
/*
 导语
    吸附行为 它能让动态元素运动到指定的点,在运动过程中可以设定弹簧效果.
 构造方法:
    - (instancetype)initWithItem:(id <UIDynamicItem>)item snapToPoint:(CGPoint)point NS_DESIGNATED_INITIALIZER;
    使用动态元素和捕获点 来构造吸附行为
    item:动态元素
    snapToPoint:捕获点
 属性:
    @property (nonatomic, assign) CGPoint snapPoint NS_AVAILABLE_IOS(9_0);
    捕获点
 
    @property (nonatomic, assign) CGFloat damping; // damping value from 0.0 to 1.0. 0.0 is the least oscillation.
    震动阻尼
    阻尼的有效范围为0.0~1.0，0.0最大震荡、1.0最小震荡，默认值为0.5
 */
#import "SnapViewController.h"

@interface SnapViewController ()
@property (nonatomic, strong) UIImageView *frog1;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"吸附行为";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.frog1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 - 50, 100, 50, 50)];
    self.frog1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.frog1];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
}
- (void)tap:(UITapGestureRecognizer *)tap{
    [self.animator removeAllBehaviors];
    CGPoint tapPoint = [tap locationInView:self.view];
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.frog1 snapToPoint:tapPoint];
    // damping value from 0.0 to 1.0. 0.0 is the least oscillation.
    //damping 振幅 决定了物体被吸附时的弹跳力度
    self.snapBehavior.damping = 0.75;
    [self.animator addBehavior:self.snapBehavior];
}

@end
