//
//  PropertiesViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//
/*
导语:
   UIDynamicItemBehavior
   UIDynamicItemBehavior 提供了更多前面几种动力学行为不曾提到的动力学属性。
   它不像其它几种行为具有比较具象的特征，它的作用更像是一个扩展，可以为一个动态元素设置更多较为具体的动力学属性。
 
构造方法:
   - (instancetype)initWithItems:(NSArray<id <UIDynamicItem>> *)items NS_DESIGNATED_INITIALIZER;
   通过动态元素来生成
属性:
   @property (readwrite, nonatomic) CGFloat elasticity; // Usually between 0 (inelastic) and 1 (collide elastically)
   弹性系数 取值范围是0.0-1.0,表示与其他物体碰撞时的弹性  0表示没有弹性  1表示反弹作用力与碰撞作用力相等
   
   @property (readwrite, nonatomic) CGFloat friction; // 0 being no friction between objects slide along each other
   摩擦系数 0.0表示没有摩擦力,1表示摩擦力很大,但可将该属性设置为大于1.0的值,以进一步增大摩擦力
  
   @property (readwrite, nonatomic) CGFloat density; // 1 by default
   相对质量密度 默认情况下 100*100 点的物体质量为1.0,100*200点的物体质量为2.0. 调整密度将影响重力和碰撞效果.默认值为1
 
   @property (readwrite, nonatomic) CGFloat resistance; // 0: no velocity damping
   线速度阻尼  取值范围为:0-CGFLOAT_MAX 0表示没有阻力,1.0表示一旦其他作用力消失,物体就会停止
 
   @property (readwrite, nonatomic) CGFloat angularResistance; // 0: no angular velocity damping
   角速度阻尼(旋转阻力) 范围是0.0-CGFLOAT_MAX  其值越大,旋转速度下降的越快
 
方法:
   - (void)addLinearVelocity:(CGPoint)velocity forItem:(id <UIDynamicItem>)item;
   添加一个动态元素，并设置它的线速度,默认值为0.0，单位点/秒。设置一个负值，减少一定线速度。
   - (CGPoint)linearVelocityForItem:(id <UIDynamicItem>)item;
   获得动态元素的线速度
 
   - (void)addAngularVelocity:(CGFloat)velocity forItem:(id <UIDynamicItem>)item;
   添加一个动态元素，并设置它的角速度 默认值为0.0，单位弧度/秒。设置一个负值，减少一定角速度。
   - (CGFloat)angularVelocityForItem:(id <UIDynamicItem>)item;
   获得动态元素的角速度
*/
#import "PropertiesViewController.h"

@interface PropertiesViewController ()
@property (nonatomic, strong) UIImageView *frog1;
@property (nonatomic, strong) UIImageView *frog2;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collosionBehavior;
@end

@implementation PropertiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"物体属性";
    
    self.frog1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 - 50, 100, 50, 50)];
    self.frog1.image = [UIImage imageNamed:@"jay"];
    [self.view addSubview:self.frog1];
    
    self.frog2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 + 25, 100, 50, 50)];
    self.frog2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.frog2];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.frog1,self.frog2]];
    
    self.collosionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.frog1,self.frog2]];
    self.collosionBehavior.translatesReferenceBoundsIntoBoundary = YES;

    UIDynamicItemBehavior *propertiesBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.frog1]];
    propertiesBehavior.elasticity = 1;
    propertiesBehavior.allowsRotation = NO;
    propertiesBehavior.angularResistance = 0;
    propertiesBehavior.density = 3;
    propertiesBehavior.friction = 0.5;
    propertiesBehavior.resistance = 0.5;
    
    [self.animator addBehavior:self.gravityBehavior];
    [self.animator addBehavior:self.collosionBehavior];
    [self.animator addBehavior:propertiesBehavior];
}
@end
