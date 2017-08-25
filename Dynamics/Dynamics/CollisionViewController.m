//
//  CollisionViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//
/*
 导语
    碰撞行为是动态元素之间极短的相互作用,参与碰撞动态元素在碰撞之后 一般在速度,方向,动量等都发生着改变
 构造方法:
    - (instancetype)initWithItems:(NSArray<id <UIDynamicItem>> *)items NS_DESIGNATED_INITIALIZER;
    通过指定动态元素的生成碰撞行为
 属性
    @property (nonatomic, readonly, copy) NSArray<id <UIDynamicItem>> *items;
    获取参与碰撞行为的动态元素,只读
 
    @property (nonatomic, readwrite) UICollisionBehaviorMode collisionMode;
    碰撞的类型
    UICollisionBehaviorModeItems        = 1 << 0,       元素碰撞 只有动态元素之间才发生碰撞行为
    UICollisionBehaviorModeBoundaries   = 1 << 1,       边界碰撞 运动元素只检测是否与边界发生碰撞，而不会检测是否与其他元素进行碰撞。
    UICollisionBehaviorModeEverything   = NSUIntegerMax 全体碰撞 运动元素和边界都会造成碰撞
 
    @property (nonatomic, readwrite) BOOL translatesReferenceBoundsIntoBoundary;
    碰撞边界的设置 NO为无边界 YES为动力学试图的边界,注意 translatesReferenceBoundsIntoBoundary属性只负责碰撞边界的设置，并不会影响碰撞的类型
 
    @property (nullable, nonatomic, readonly, copy) NSArray<id <NSCopying>> *boundaryIdentifiers;
    获得所有碰撞边界的命名 只读
 
    @property (nullable, nonatomic, weak, readwrite) id <UICollisionBehaviorDelegate> collisionDelegate;
    碰撞行为的代理
 
 方法:
    - (void)addItem:(id <UIDynamicItem>)item;
    添加一个动态元素
 
    - (void)removeItem:(id <UIDynamicItem>)item;
    删除一个动态元素
 
    - (void)setTranslatesReferenceBoundsIntoBoundaryWithInsets:(UIEdgeInsets)insets;
    用来设置碰撞Reference View边界的内边距 注意:setTranslatesReferenceBoundsIntoBoundaryWithInsets:函数和translatesReferenceBoundsIntoBoundary属性设置的边界是相互独立的，两者之间没有联系
 
    - (void)addBoundaryWithIdentifier:(id <NSCopying>)identifier forPath:(UIBezierPath *)bezierPath;
    通过添加贝塞尔曲线，添加碰撞边界
    identifier:该边界的标识
    bezierPath:贝塞尔曲线
 
    - (void)addBoundaryWithIdentifier:(id <NSCopying>)identifier fromPoint:(CGPoint)p1 toPoint:(CGPoint)p2;
    通过添加由两点组成的线段，添加碰撞边界
    identifier:该边界的标识
    fromPoint:线的起点
    toPoint:线的终点
 
    - (nullable UIBezierPath *)boundaryWithIdentifier:(id <NSCopying>)identifier;
    根据获取指定已命名的碰撞边界的贝塞尔曲线
 
    - (void)removeBoundaryWithIdentifier:(id <NSCopying>)identifier;
    移除指定已命名的碰撞边界
 
    - (void)removeAllBoundaries;
    移除所有添加的碰撞边界
 
UICollisionBehaviorDelegate 方法
    1.动态元素之间的碰撞
    - (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p;
    当两个 动态元素 之间发生碰撞时候调用
    behavior:当前碰撞时的碰撞行为
    item1:动态元素1
    item2:动态元素2
    atPoint:碰撞点
 
    - (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2;
     当两个 动态元素 之间碰撞结束时调用
     behavior:当前碰撞时的碰撞行为
     item1:动态元素1
     item2:动态元素2
 
    2.动态元素与碰撞边界之间发生碰撞
 
    - (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p;
    动态元素与碰撞边界发生碰撞时调用
    behavior:当前碰撞时的碰撞行为
    item:发生碰撞的动态元素
    identifier:边界的标识
    atPoint:碰撞点
 
    - (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier;
    动态元素与碰撞边界碰撞结束时调用
    behavior:当前碰撞时的碰撞行为
    item:发生碰撞的动态元素
    identifier:边界的标识
*/
#import "CollisionViewController.h"

@interface CollisionViewController ()<UICollisionBehaviorDelegate>
@property (nonatomic, strong) UIImageView *frog1;
@property (nonatomic, strong) UIImageView *frog2;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collosionBehavior;
@end

@implementation CollisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"碰撞行为";

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 64 , self.view.frame.size.width, self.view.frame.size.width) cornerRadius:self.view.frame.size.width * 0.5];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;
    [self.view.layer addSublayer:shapeLayer];

    
    self.frog1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 - 25, 100, 50, 50)];
    self.frog1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.frog1];
    
    self.frog2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 + 25, 100, 50, 50)];
    self.frog2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.frog2];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.frog1,self.frog2]];
    
    self.collosionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.frog1,self.frog2]];
    //    collisionMode:
    
    //    UICollisionBehaviorModeItems          元素碰撞 物体相互碰撞
    //    UICollisionBehaviorModeBoundaries     边界碰撞 物体不相互碰撞,只与边界碰撞
    //    UICollisionBehaviorModeEverything     全体碰撞 集相互碰撞又与边界碰撞
    self.collosionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    
    //    translatesReferenceBoundsIntoBoundary:是否以参照视图的bounds为边界
//    self.collosionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
//    设置参照视图的bounds为边界，并且设置内边距
//    [self.collosionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(100, 100, 100, 100)];
    
    //使用贝塞尔曲线 设置碰撞边界
    [self.collosionBehavior addBoundaryWithIdentifier:@"bouns1" forPath:bezierPath];
    
    // 设置碰撞行为的代理
    self.collosionBehavior.collisionDelegate = self;
    
    [self.animator addBehavior:self.gravityBehavior];
    [self.animator addBehavior:self.collosionBehavior];
}
//处理 items 之间的碰撞
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    //items 之间只要发生碰撞就会执行该代理,可能执行多次
    NSLog(@"相互碰撞");
    NSLog(@"item1.centerX = %f  item1.centerY = %f",item1.center.x,item1.center.y);
    NSLog(@"item2.centerX = %f  item2.centerY = %f",item2.center.x,item2.center.y);
    NSLog(@"p.X = %f  p.Y = %f",p.x,p.y);

}
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2
{
    //items 之间碰撞的时候物体碰撞结束时候调用
    NSLog(@"相互分离");
    NSLog(@"item1.centerX = %f  item1.centerY = %f",item1.center.x,item1.center.y);
    NSLog(@"item2.centerX = %f  item2.centerY = %f",item2.center.x,item2.center.y);
}

//items 和   boundary 之间的碰撞
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p
{
    //items 与 边界发生碰撞
    NSLog(@"items 与 边界发生碰撞");
    NSLog(@"item.centerX = %f  item.centerY = %f",item.center.x,item.center.y);
    NSLog(@"identifier === %@",identifier);
    NSLog(@"p.X = %f  p.Y = %f",p.x,p.y);
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier
{
    //items 与 边界发生碰撞之后分离
    NSLog(@"items 与 边界发生碰撞之后分离");
    NSLog(@"item.centerX = %f  item.centerY = %f",item.center.x,item.center.y);
    NSLog(@"identifier === %@",identifier);
}

@end
