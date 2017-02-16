//
//  LDGestureLockView.h
//  GestureLock
//
//  Created by Done.L (liudongdong@qiyoukeji.com) on 2017/2/7.
//  Copyright © 2017年 Done.L (liudongdong@qiyoukeji.com). All rights reserved.
//

#import <UIKit/UIKit.h>

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@class LDGestureLockView;

@protocol LDGestureLockViewDelegate <NSObject>

- (void)ld_getsureLockView:(LDGestureLockView *)gestureLockView drawRectFinished:(NSMutableString *)gestureLockPassword;

@end

@interface LDGestureLockView : UIView

@property (nonatomic, assign) id<LDGestureLockViewDelegate> delegate;

@end
