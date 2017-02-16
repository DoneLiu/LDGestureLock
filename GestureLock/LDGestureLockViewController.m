//
//  LDGestureLockViewController.m
//  GestureLock
//
//  Created by Done.L (liudongdong@qiyoukeji.com) on 2017/2/7.
//  Copyright © 2017年 Done.L (liudongdong@qiyoukeji.com). All rights reserved.
//

#import "LDGestureLockViewController.h"

#import "LDGestureLockView.h"
#import "LDGestureLockIndicator.h"

#import "Masonry.h"
#import "MMPlaceHolder.h"

static NSString *GESTURE_LOCK_PASSWORD = @"ld_gesture_lock_password";

static CGFloat HORIZONTAL_SHAKE_RANGE = 10.f;
static NSInteger GESTURE_PASSWORD_LENGTH_LIMIT = 4;

static CGFloat USER_AVATAR_TOP_MARGIN;
static CGFloat GESTURE_LOCK_VIEW_SCALE;

@interface LDGestureLockViewController () <LDGestureLockViewDelegate>

@property (nonatomic, strong) LDGestureLockView *gestureLockView;
@property (nonatomic, strong) LDGestureLockIndicator *gestureLockIndicator;
@property (nonatomic, strong) UILabel *status;

@property (nonatomic, strong) UIButton *otherAccountLogin;
@property (nonatomic, strong) UIButton *forgetGesturePassword;
@property (nonatomic, strong) UIButton *resetGesturePassword;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIImageView *userAvatar;

@property (nonatomic, assign) LDGestureLockType gestureLockType;

@property (nonatomic, copy) NSString *latestGesturePassword;

@end

@implementation LDGestureLockViewController

#pragma mark - Init

- (instancetype)initWithGestureLockType:(LDGestureLockType)gestureLockType {
    if (self = [super init]) {
        _gestureLockType = gestureLockType;
    }
    return self;
}

#pragma mark - Getter

- (LDGestureLockView *)gestureLockView {
    if (!_gestureLockView) {
        _gestureLockView = [[LDGestureLockView alloc] init];
        [self.view addSubview:_gestureLockView];
        
        [_gestureLockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(_status.mas_bottom);
            make.height.mas_equalTo(@(self.view.frame.size.width * GESTURE_LOCK_VIEW_SCALE));
            make.width.mas_equalTo(@(self.view.frame.size.width * GESTURE_LOCK_VIEW_SCALE));
        }];
    }
    return _gestureLockView;
}

- (LDGestureLockIndicator *)gestureLockIndicator {
    if (!_gestureLockIndicator) {
        _gestureLockIndicator = [[LDGestureLockIndicator alloc] init];
        [self.view addSubview:_gestureLockIndicator];
        
        [_gestureLockIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(@(USER_AVATAR_TOP_MARGIN));
            make.width.mas_equalTo(@(56));
            make.height.mas_equalTo(@(56));
        }];
    }
    return _gestureLockIndicator;
}

- (UILabel *)status {
    if (!_status) {
        _status = [[UILabel alloc] init];
        _status.font = [UIFont systemFontOfSize:14.f];
        _status.textColor = [UIColor redColor];
        _status.textAlignment = NSTextAlignmentCenter;
        _status.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.view addSubview:_status];
        
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_userName);
            make.top.mas_equalTo(_userName.mas_bottom);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(@(24));
        }];
    }
    return _status;
}

- (UIButton *)otherAccountLogin {
    if (!_otherAccountLogin) {
        _otherAccountLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherAccountLogin.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_otherAccountLogin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_otherAccountLogin setTitle:@"其他账号登录" forState:UIControlStateNormal];
        [_otherAccountLogin addTarget:self action:@selector(otherAccountLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_otherAccountLogin];
        
        [_otherAccountLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(@(- self.view.bounds.size.width / 4));
            make.height.mas_equalTo(@(60));
            make.width.mas_equalTo(@(self.view.bounds.size.width / 2));
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }
    return _otherAccountLogin;
}

- (UIButton *)forgetGesturePassword {
    if (!_forgetGesturePassword) {
        _forgetGesturePassword = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetGesturePassword.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_forgetGesturePassword setTitleColor:UIColorFromRGB(0x0aa4ea) forState:UIControlStateNormal];
        [_forgetGesturePassword setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [_forgetGesturePassword addTarget:self action:@selector(forgetGesturePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetGesturePassword];
        
        [_forgetGesturePassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(@(self.view.bounds.size.width / 4));
            make.height.mas_equalTo(@(60));
            make.width.mas_equalTo(@(self.view.bounds.size.width / 2));
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }
    return _forgetGesturePassword;
}

- (UIButton *)resetGesturePassword {
    if (!_resetGesturePassword) {
        _resetGesturePassword = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetGesturePassword.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_resetGesturePassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_resetGesturePassword setTitle:@"重置手势密码" forState:UIControlStateNormal];
        [_resetGesturePassword addTarget:self action:@selector(resetGesturePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_resetGesturePassword];
        
        [_resetGesturePassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(@(60));
            make.width.mas_equalTo(@(self.view.bounds.size.width / 2));
            make.bottom.mas_equalTo(self.view.mas_bottom);

        }];
    }
    return _resetGesturePassword;
}

- (UIImageView *)userAvatar {
    if (!_userAvatar) {
        _userAvatar = [[UIImageView alloc] init];
        _userAvatar.image = [UIImage imageNamed:@"gesture_headIcon"];
        [self.view addSubview:_userAvatar];
        
        [_userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(@(USER_AVATAR_TOP_MARGIN));
            make.width.mas_equalTo(@(56));
            make.height.mas_equalTo(@(56));
        }];
    }
    return _userAvatar;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.font = [UIFont systemFontOfSize:14.f];
        _userName.textColor = [UIColor orangeColor];
        _userName.textAlignment = NSTextAlignmentCenter;
        _userName.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.view addSubview:_userName];
        
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_userAvatar);
            make.top.mas_equalTo(_userAvatar.mas_bottom);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(@(24));
        }];
    }
    return _userName;
}

#pragma mark - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (Screen_Height == 480) {
        USER_AVATAR_TOP_MARGIN = 44;
        GESTURE_LOCK_VIEW_SCALE = 0.85;
    } else {
        USER_AVATAR_TOP_MARGIN = 64;
        GESTURE_LOCK_VIEW_SCALE = 1;
    }
    
    switch (_gestureLockType) {
        case LDGestureLockTypeCreatePassword: {
            self.gestureLockIndicator.hidden = NO;
            self.userAvatar.hidden = YES;
            self.userName.hidden = YES;
            self.status.text = @"请绘制手势密码";
            self.otherAccountLogin.hidden = YES;
            self.forgetGesturePassword.hidden = YES;
            self.resetGesturePassword.hidden = YES;
        }
            break;
        case LDGestureLockTypeValidatePassword: {
            self.gestureLockIndicator.hidden = YES;
            self.userAvatar.hidden = NO;
            self.userName.hidden = NO;
            self.userName.text = @"Done.Liu";
            self.status.text = @"请输入手势密码";
            self.otherAccountLogin.hidden = NO;
            self.forgetGesturePassword.hidden = NO;
            self.resetGesturePassword.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    self.gestureLockView.delegate = self;
}

#pragma mark - LDGestureLockViewDelegate

- (void)ld_getsureLockView:(LDGestureLockView *)gestureLockView drawRectFinished:(NSMutableString *)gestureLockPassword {
    switch (_gestureLockType) {
        case LDGestureLockTypeCreatePassword: {
            [self createGestureLockPassword:gestureLockPassword];
        }
            break;
        case LDGestureLockTypeValidatePassword: {
            [self validateGestureLockPassword:gestureLockPassword];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Publicb

+ (NSString *)gestureLockPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:GESTURE_LOCK_PASSWORD];
}

+ (void)deleteGestureLockPassword {
    if ([LDGestureLockViewController gestureLockPassword]) {
        NSLog(@"deleteGestureLockPassword success !");
    
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:GESTURE_LOCK_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSLog(@"no gesture password now !");
    }
}

#pragma mark - Private

- (void)createGestureLockPassword:(NSMutableString *)gestureLockPassword {
    if (self.latestGesturePassword.length == 0) {
        if (gestureLockPassword.length < GESTURE_PASSWORD_LENGTH_LIMIT) {
            self.status.text = @"至少连接四个点，请重新输入";
            [self shakeAnimationForView:self.status];
            return;
        }
        
        if (self.resetGesturePassword.hidden == YES) {
            self.resetGesturePassword.hidden = NO;
        }
        
        self.latestGesturePassword = gestureLockPassword;
        [self.gestureLockIndicator setGestureLockPassword:gestureLockPassword];
        self.status.text = @"请再次绘制手势密码";
        return;
    }
    
    if ([self.latestGesturePassword isEqualToString:gestureLockPassword]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self addGestureLockPassword:gestureLockPassword];
        }];
    } else {
        self.status.text = @"与上一次绘制不一致，请重新绘制";
        [self shakeAnimationForView:self.status];
    }
}

- (void)validateGestureLockPassword:(NSMutableString *)gestureLockPassword {
    static NSInteger errorCount = 5;
    
    if ([gestureLockPassword isEqualToString:[LDGestureLockViewController gestureLockPassword]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (errorCount - 1 == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手势密码已失效" message:@"请重新登陆" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *reLogin = [UIAlertAction actionWithTitle:@"重新登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self reLogin];
            }];
            [alert addAction:reLogin];
            [self presentViewController:alert animated:YES completion:nil];
            
            errorCount = 5;
            return;
        }
        
        self.status.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次", --errorCount];
        [self shakeAnimationForView:self.status];
    }
}

- (void)shakeAnimationForView:(UIView *)shakeView {
    CALayer *layer = shakeView.layer;
    CGPoint position = layer.position;
    CGPoint left = CGPointMake(position.x - HORIZONTAL_SHAKE_RANGE, position.y);
    CGPoint right = CGPointMake(position.x + HORIZONTAL_SHAKE_RANGE, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [layer addAnimation:animation forKey:nil];
}

- (void)addGestureLockPassword:(NSMutableString *)gestureLockPassword {
    [[NSUserDefaults standardUserDefaults] setObject:gestureLockPassword forKey:GESTURE_LOCK_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reLogin {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ld_gestureLockReLogin)]) {
        [self.delegate ld_gestureLockReLogin];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Button

- (void)otherAccountLoginClick:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ld_gestureLockOtherAccountLogin)]) {
        [self.delegate ld_gestureLockOtherAccountLogin];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)forgetGesturePasswordClick:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ld_gestureLockForgetGesturePassword)]) {
        [self.delegate ld_gestureLockForgetGesturePassword];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)resetGesturePasswordClick:(UIButton *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    self.latestGesturePassword = nil;
    self.status.text = @"请绘制手势密码";
    self.resetGesturePassword.hidden = YES;
    [self.gestureLockIndicator setGestureLockPassword:nil];
}

- (void)dealloc {
    NSLog(@"LDGestureLockViewController dealloc !");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
