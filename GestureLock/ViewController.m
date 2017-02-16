//
//  ViewController.m
//  GestureLock
//
//  Created by Done.L (liudongdong@qiyoukeji.com) on 2017/2/7.
//  Copyright © 2017年 Done.L (liudongdong@qiyoukeji.com). All rights reserved.
//

#import "ViewController.h"

#import "LDGestureLockViewController.h"

@interface ViewController () <LDGestureLockViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *create = [UIButton buttonWithType:UIButtonTypeCustom];
    create.frame = CGRectMake(self.view.center.x - 100, self.view.center.y - 125, 200, 50);
    [create setTitle:@"创建手势密码" forState:UIControlStateNormal];
    [create setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [create addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:create];
    
    UIButton *validate = [UIButton buttonWithType:UIButtonTypeCustom];
    validate.frame = CGRectMake(self.view.center.x - 100, self.view.center.y, 200, 50);
    [validate setTitle:@"验证手势密码" forState:UIControlStateNormal];
    [validate setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [validate addTarget:self action:@selector(validate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:validate];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(self.view.center.x - 100, self.view.center.y + 125, 200, 50);
    [delete setTitle:@"删除手势密码" forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete];
}

- (void)create {
    LDGestureLockViewController *vc = [[LDGestureLockViewController alloc] initWithGestureLockType:LDGestureLockTypeCreatePassword];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)validate {
    LDGestureLockViewController *vc = [[LDGestureLockViewController alloc] initWithGestureLockType:LDGestureLockTypeValidatePassword];
    vc.username = @"Done.Liu";
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)delete {
    [LDGestureLockViewController deleteGestureLockPassword];
}

- (void)ld_gestureLockReLogin {
    NSLog(@"ld_gestureLockReLogin");
}

- (void)ld_gestureLockForgetGesturePassword {
    NSLog(@"ld_gestureLockForgetGesturePassword");
}

- (void)ld_gestureLockOtherAccountLogin {
    NSLog(@"ld_gestureLockOtherAccountLogin");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
