//
//  AttachmentsViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//
/*
 导语
    连接行为 指定了两个物体之间的动态连接,让一个物体的行为和移动受制于另一个物体的移动.默认UIAttachmentBehavior将物体的中心指定为连接点,但可将任何点指定为连接点.
    连接主要发生在：元素与锚点、元素与元素之间。
    当元素与锚点连接，元素的运动依赖于锚点。
    当元素与元素连接，两个元素的运动彼此影响。
    有的连接行为支持两个元素和一个锚点。
 
 构造方法:
    1.元素与锚点之间
    - (instancetype)initWithItem:(id <UIDynamicItem>)item attachedToAnchor:(CGPoint)point;
    通过指定的动态元素和连接点 来构造一个连接行为
    item:动态元素对象
    attachedToAnchor:连接点(锚点)
 
    - (instancetype)initWithItem:(id <UIDynamicItem>)item offsetFromCenter:(UIOffset)offset attachedToAnchor:(CGPoint)point NS_DESIGNATED_INITIALIZER;
    通过指定的动态元素和连接点以及连接点的一个偏移量 来构造一个连接行为
    item:动态元素对象
    attachedToAnchor:连接点(锚点)
    offsetFromCenter:给元素的连接点一个偏移量
    
    2.元素与元素之间
    - (instancetype)initWithItem:(id <UIDynamicItem>)item1 attachedToItem:(id <UIDynamicItem>)item2;
    使用两个动力元素 来构造一个连接行为,彼此互相牵连
    item1:动态元素对象
    item2:动态元素对象
 
    - (instancetype)initWithItem:(id <UIDynamicItem>)item1 offsetFromCenter:(UIOffset)offset1 attachedToItem:(id <UIDynamicItem>)item2 offsetFromCenter:(UIOffset)offset2 NS_DESIGNATED_INITIALIZER;
    使用两个动力元素 来构造一个连接行为,彼此互相牵连
    item1:动态元素对象
    attachedToItem:对于动态元素1的作用点的偏移量
    item2:动态元素对象
    offsetFromCenter:对于动态元素2的作用点的偏移量
 
 
    属性:
    @property (nonatomic, readonly, copy) NSArray<id <UIDynamicItem>> *items;
    动态元素数组,只读
 
    @property (readonly, nonatomic) UIAttachmentBehaviorType attachedBehaviorType;
    连接行为的类型,只读
    UIAttachmentBehaviorTypeItems,   动态元素与动态元素之间
    UIAttachmentBehaviorTypeAnchor   动态元素与锚点之间
 
    @property (readwrite, nonatomic) CGPoint anchorPoint;
    当吸附发生在元素和锚点之间的时候，我们可以通过anchorPoint属性获得锚点位置，如果吸附发生在元素和元素之间的时候，该属性的值为(0, 0)
 
    @property (readwrite, nonatomic) CGFloat length;
    元素吸附力作用点和锚点的距离 或 两个元素吸附力作用点间的距离
    当连接行为为UIAttachmentBehaviorTypeAnchor时,表示动态元素到锚点的距离
    当连接行为为UIAttachmentBehaviorTypeItems时,表示两个动态元素的距离
 
    @property (readwrite, nonatomic) CGFloat damping; // 1: critical damping
    damping属性是设置元素在弹性吸附时震动所受到的阻力，值越大，阻力越大，弹性运动震动的幅度越小。
 
    @property (readwrite, nonatomic) CGFloat frequency; // in Hertz
    frequency属性是指元素在发生弹性吸附时震动的频率，值越大，弹性运动的频率越快。
 
    @property (readwrite, nonatomic) CGFloat frictionTorque NS_AVAILABLE_IOS(9_0); // default is 0.0
    frictionTorque为旋转力矩，指围绕一点旋转所受的阻力，默认值0.0，值越大，阻力越大。
 
    @property (readwrite, nonatomic) UIFloatRange attachmentRange NS_AVAILABLE_IOS(9_0); // default is UIFloatRangeInfinite
    运动范围
 
*/
#import "AttachmentsViewController.h"

@interface AttachmentsViewController ()
@property (nonatomic, strong) UIImageView *frog1;
@property (nonatomic, strong) UIImageView *frog2;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior1;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior2;

@property (nonatomic, strong) UICollisionBehavior *collosionBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@end

@implementation AttachmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"连接行为";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.frog1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 - 50, 100, 50, 50)];
    self.frog1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.frog1];
    
    self.frog2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 + 25, 100+100, 50, 50)];
    self.frog2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.frog2];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.collosionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.frog1,self.frog2]];
    self.collosionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collosionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    self.gravityBehavior1 = [[UIGravityBehavior alloc] initWithItems:@[self.frog1]];
    [self.gravityBehavior1 setGravityDirection:CGVectorMake(1, 1)];
    self.gravityBehavior2 = [[UIGravityBehavior alloc] initWithItems:@[self.frog2]];
    [self.gravityBehavior2 setAngle:M_PI_2 magnitude:0.9];

    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.frog1 offsetFromCenter:UIOffsetMake(25, 0) attachedToItem:self.frog2 offsetFromCenter:UIOffsetMake(-25, 0)];
    self.attachmentBehavior.length = 150;
    
    [self.animator addBehavior:self.gravityBehavior1];
    [self.animator addBehavior:self.gravityBehavior2];

    [self.animator addBehavior:self.attachmentBehavior];
    [self.animator addBehavior:self.collosionBehavior];
}

@end
