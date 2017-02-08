//
//  LDGestureLockView.m
//  GestureLock
//
//  Created by Done.L (liudongdong@qiyoukeji.com) on 2017/2/7.
//  Copyright © 2017年 Done.L (liudongdong@qiyoukeji.com). All rights reserved.
//

#import "LDGestureLockView.h"

static NSInteger BUTTON_TAG = 1000;

@interface LDGestureLockView ()

@property (nonatomic, strong) NSMutableArray *selectedBtns;
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation LDGestureLockView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
        btn.tag = BUTTON_TAG + i;
        [self addSubview:btn];
    }
}

#pragma mark - Pan
    
- (void)pan:(UIPanGestureRecognizer *)pan {
    _currentPoint = [pan locationInView:self];
    
    [self setNeedsDisplay];
    
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected ==   NO) {
            button.selected = YES;
            [self.selectedBtns addObject:button];
        }
    }
    
    [self layoutIfNeeded];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        NSMutableString *gestureLockPassword = @"".mutableCopy;
        for (UIButton *button in self.selectedBtns) {
            [gestureLockPassword appendFormat:@"%ld", button.tag - BUTTON_TAG];
            button.selected = NO;
        }
        
        [self.selectedBtns removeAllObjects];
        
        if ([self.delegate respondsToSelector:@selector(getsureLockView:drawRectFinished:)]) {
            [self.delegate getsureLockView:self drawRectFinished:gestureLockPassword];
        }
    }
}

- (NSMutableArray *)selectedBtns {
    if (!_selectedBtns) {
        _selectedBtns = @[].mutableCopy;
    }
    return _selectedBtns;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    
    NSInteger columns = 3;//总列数
    
    CGFloat x = 0,y = 0,w = 0,h = 0;
    
    if (Screen_Width == 320) {
        w = 50;
        h = 50;
    } else {
        w = 58;
        h = 58;
    }
    
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

- (void)drawRect:(CGRect)rect {
    if (self.selectedBtns.count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger count = self.selectedBtns.count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = self.selectedBtns[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        } else {
            [path addLineToPoint:btn.center];
        }
    }
    
    [path addLineToPoint:_currentPoint];
    
    [UIColorFromRGB(0xffc8ad) set];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 8;
    [path stroke];
}

@end
