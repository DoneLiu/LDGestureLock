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

@interface LDGestureLockViewController : UIViewController

- (NSString *)gestureLockPassword;

- (instancetype)initWithGestureLockType:(LDGestureLockType)gestureLockType;

@end
