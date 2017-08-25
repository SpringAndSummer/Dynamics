//
//  GravityViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//

#import "GravityViewController.h"
/*
  导语
     重力行为
     物体由于受到吸引力的吸引而产生的运动
  构造方法:
     - (instancetype)initWithItems:(NSArray<id <UIDynamicItem>> *)items NS_DESIGNATED_INITIALIZER;
     通过指定动态元素来生成重力行为
  属性:
     @property (nonatomic, readonly, copy) NSArray<id <UIDynamicItem>> *items;
     参与重力行为的动态元素,只读
 
     @property (readwrite, nonatomic) CGVector gravityDirection;
     重力的矢量的方向
 
     @property (readwrite, nonatomic) CGFloat angle;
     重力矢量方向与坐标轴x的夹角
 
     @property (readwrite, nonatomic) CGFloat magnitude;
     magnitude是重力加速度的倍数
  方法:
     - (void)addItem:(id <UIDynamicItem>)item;
     添加动态元素
     - (void)removeItem:(id <UIDynamicItem>)item;
     删除动态元素
     - (void)setAngle:(CGFloat)angle magnitude:(CGFloat)magnitude;
     设置重力矢量方向与坐标轴x的夹角和重力加速度的倍数
 */
@interface GravityViewController ()
@property (nonatomic, strong) UIImageView *frog;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@end

@implementation GravityViewController
//@property (nonatomic, readonly, copy) NSArray<</span>id<</span>UIDynamicItem>> *items;
//
//// The default value for the gravity vector is (0.0, 1.0)
//
//// The acceleration for a dynamic item subject to a (0.0, 1.0) gravity vector is downwards at 1000 points per second².
//
//@property (readwrite, nonatomic) CGVector gravityDirection;
//
//@property (readwrite, nonatomic) CGFloat angle;
//
//@property (readwrite, nonatomic) CGFloat magnitude;
//这是UIGravityBehavior的四个属性，
//
//items是模拟重力行为的模拟对象数组；
//
//angle重力矢量方向与坐标轴x的夹角，例如垂直向下：π/2；
//
//magnitude是重力加速度的倍数；
//
//vector看结构就是一个点，从坐标原点向这个点连线就是一个矢量，也就是重力的方向，默认是(0.0, 1.0)。这个属性的数据量很丰富，由这个点向X轴和Y轴分别做垂线构成了一个矩形，对角线与X轴夹角就是重力加速度的方向，即angle，对角线的长度就是重力加速度的值，即magnitude。也就是说我们完全可以用gravityDirection变量确定angle和magnitude的值，反之用angle和magnitude也可以确定gravityDirection的值。
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"重力行为";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.frog = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5, 100, 50, 50)];
    self.frog.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.frog];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
     self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.frog]];
    
    self.gravityBehavior.gravityDirection = CGVectorMake(0.0, 1);
//    [self.gravityBehavior setAngle:5 magnitude:5];
    [self.animator addBehavior:self.gravityBehavior];
}
@end
