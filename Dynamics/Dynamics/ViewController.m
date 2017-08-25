//
//  ViewController.m
//  Dynamics
//
//  Created by 曹相召 on 2017/8/24.
//  Copyright © 2017年 曹相召. All rights reserved.
//

#import "ViewController.h"
#import "GravityViewController.h"
#import "CollisionViewController.h"
#import "AttachmentsViewController.h"
#import "SpringViewController.h"
#import "SnapViewController.h"
#import "ForcesViewController.h"
#import "PropertiesViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"仿真行为";
    
    self.dataArr = @[@"Gravity(重力)",@"Collisions(碰撞)",@"Attachments(连接)",@"Springs(弹簧)",@"snap(吸附)",@"Forces(推力)",@"Properties(物体属性)"];
    
    self.listView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    [self.view addSubview:self.listView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.dataArr[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        GravityViewController *vc = [[GravityViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1){
        CollisionViewController *vc = [[CollisionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        AttachmentsViewController *vc = [[AttachmentsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        SpringViewController *vc = [[SpringViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        SnapViewController *vc = [[SnapViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5){
        ForcesViewController *vc = [[ForcesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6){
        PropertiesViewController *vc = [[PropertiesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
