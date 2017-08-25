//
//  ForcesViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//
/*
 导语
 推动行为是将一个推力作用到受力元素上，就好像是‘一股气流’作用在物体上，可以是持续的，也可以是瞬间的，可以设置方向和大小，也可以改变作用力的中心。
   
 构造方法:
 - (instancetype)initWithItems:(NSArray<id <UIDynamicItem>> *)items mode:(UIPushBehaviorMode)mode NS_DESIGNATED_INITIALIZER;
 其中:items 为添加的动态元素
 mode  为推动行为的类型   
       UIPushBehaviorModeContinuous     持续的推动
       UIPushBehaviorModeInstantaneous  瞬间的推动

 方法:
 - (void)setTargetOffsetFromCenter:(UIOffset)o forItem:(id <UIDynamicItem>)item;
   该方法是设置 作用力中心偏移量(如果作用力在物体的中心,则物体只会平移的被推出,如果有作用力的中心偏移量,则就会产生推动时旋转效果)

 - (UIOffset)targetOffsetFromCenterForItem:(id <UIDynamicItem>)item;
   该方法是获取动态元素的 作用力中心偏移量
 
 - (void)setAngle:(CGFloat)angle magnitude:(CGFloat)magnitude;
   设置推动力的大小和方向
   angle:    推力的角度
   magnitude:推力矢量的大小
 属性:
   @property (nonatomic, readonly) UIPushBehaviorMode mode;  //推动类型(只读)
   @property (nonatomic, readwrite) BOOL active;             //推动行为是否处于活跃状态
   //注意:在添加一个push behavior到animator时，使用这个属性来激活或禁用推力作用，而不是通过重新添加behavior来实现。
   @property (readwrite, nonatomic) CGFloat angle;           //推力的角度
   @property (readwrite, nonatomic) CGFloat magnitude;       //默认值为nil，没有任何力量。当设置一个负值，力的方向改变。
   @property (readwrite, nonatomic) CGVector pushDirection;  //推力矢量的方向
*/
#import "ForcesViewController.h"
#import <math.h>
@interface ForcesViewController ()
@property (nonatomic, strong) UIImageView *frog1;
@property (nonatomic, strong) UIImageView *frog2;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collosionBehavior;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;

@end

@implementation ForcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推力行为";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.frog1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 - 50, 100, 50, 50)];
    self.frog1.image = [UIImage imageNamed:@"jay"];
    [self.view addSubview:self.frog1];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.collosionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.frog1]];
    
    self.collosionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    //UIPushBehaviorMode 推动作用的类型
    //UIPushBehaviorModeContinuous      连续的推动
    //UIPushBehaviorModeInstantaneous   瞬间的推动
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.frog1] mode:UIPushBehaviorModeInstantaneous];
    [self.animator addBehavior:self.pushBehavior];
    [self.animator addBehavior:self.collosionBehavior];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.view];
    CGPoint origin = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    CGFloat distance = sqrtf(powf(point.x - origin.x, 2)) + powf(point.y - origin.y, 2);
    CGFloat angle = atan2(point.y - origin.y, point.x - origin.x);
    distance = MIN(distance, 100);
    
    [self.pushBehavior setMagnitude:distance / 100.0];
    [self.pushBehavior setAngle:angle];
    
    //setTargetOffsetFromCenter: forItem 我通过这个方法获取指定元素的作用力点偏移量
    UIOffset offset = UIOffsetMake(1, 5);
    [self.pushBehavior setTargetOffsetFromCenter:offset forItem:self.frog1];
    
    //推动行为是否处于活跃状态
    //在添加一个push behavior到animator时，使用这个属性来激活或禁用推力作用，而不是通过重新添加behavior来实现。
    [self.pushBehavior setActive:YES];
}
@end
