//
//  LDGestureLockIndicator.m
//  GestureLock
//
//  Created by Done.L (liudongdong@qiyoukeji.com) on 2017/2/7.
//  Copyright © 2017年 Done.L (liudongdong@qiyoukeji.com). All rights reserved.
//

#import "LDGestureLockIndicator.h"

@interface LDGestureLockIndicator ()

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation LDGestureLockIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_indicator_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_indicator_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
        [self.buttons addObject:btn];
    }
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = @[].mutableCopy;
    }
    return _buttons ;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    NSInteger columns = 3;//总列数
    
    CGFloat x = 0,y = 0,w = 9,h = 9;
    CGFloat margin = (self.bounds.size.width - columns * w) / (columns + 1);//间距
    
    CGFloat column = 0;
    CGFloat row = 0;
    for (NSInteger i = 0; i < count; i++) {
        column = i % columns;
        row = i / columns;
        
        x = margin + (w + margin) * column;
        y = margin + (w + margin) * row;
        
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}

#pragma mark - Public

- (void)setGestureLockPassword:(NSString *)gestureLockPassword {
    
    if (gestureLockPassword.length == 0) {
        for (UIButton *button in self.buttons) {
            button.selected = NO;
        }
        return;
    }
    
    for (int i = 0; i < gestureLockPassword.length; i++) {
        NSString *s = [gestureLockPassword substringWithRange:NSMakeRange(i, 1)];
        [self.buttons[s.integerValue] setSelected:YES];
    }
}

@end
