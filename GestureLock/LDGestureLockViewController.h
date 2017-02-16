//
//  LDGestureLockViewController.h
//  GestureLock
//
//  Created by Done.L (liudongdong@qiyoukeji.com) on 2017/2/7.
//  Copyright © 2017年 Done.L (liudongdong@qiyoukeji.com). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LDGestureLockType) {
    LDGestureLockTypeCreatePassword,    // 创建手势密码
    LDGestureLockTypeValidatePassword   // 验证手势密码
};

@protocol LDGestureLockViewControllerDelegate <NSObject>

// 其它账号登录操作
- (void)ld_gestureLockOtherAccountLogin;

// 忘记密码操作
- (void)ld_gestureLockForgetGesturePassword;

// 重新登录操作
- (void)ld_gestureLockReLogin;

@end

@interface LDGestureLockViewController : UIViewController

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) UIImage *userHeadIcon;

@property (nonatomic, assign) id<LDGestureLockViewControllerDelegate> delegate;

- (instancetype)initWithGestureLockType:(LDGestureLockType)gestureLockType;

// 用于判断是否设置了手势密码
+ (NSString *)gestureLockPassword;

// 删除手势密码
+ (void)deleteGestureLockPassword;

@end
