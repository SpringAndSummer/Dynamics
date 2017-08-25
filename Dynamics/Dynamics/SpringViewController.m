//
//  SpringViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//
/*
 导语
    弹性行为是对连接行为的扩展.
    详情请看连接行为的解释.
*/
#import "SpringViewController.h"

@interface SpringViewController ()
@property (nonatomic, strong) UIImageView *frog1;
@property (nonatomic, strong) UIImageView *frog2;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collosionBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@end

@implementation SpringViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"弹簧仿真";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.frog1 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 - 50, 100, 50, 50)];
    self.frog1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.frog1];
    
    self.frog2 = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) * 0.5 + 25, 100, 50, 50)];
    self.frog2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.frog2];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.frog1]];
    self.collosionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.frog1,self.frog2]];
    
    self.collosionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collosionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    CGPoint frogPoing = CGPointMake(self.frog2.center.x, self.frog2.center.y);
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.frog1 attachedToAnchor:frogPoing];
    
    //setFrequency  设置震动频率
    //setDamping    设置烫平动画峰值
    //setLength     设置连接的长度
    [self.attachmentBehavior setFrequency:1.0];
    [self.attachmentBehavior setDamping:0.5];
    [self.attachmentBehavior setLength:200];
    
    [self.animator addBehavior:self.gravityBehavior];
    [self.animator addBehavior:self.attachmentBehavior];
    [self.animator addBehavior:self.collosionBehavior];
}
@end
