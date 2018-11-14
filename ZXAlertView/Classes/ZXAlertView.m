//
//  ZXAlertView.m
//  ZXAlertView_Example
//
//  Created by 阮巧华 on 2018/11/14.
//  Copyright © 2018 ruanqiaohua. All rights reserved.
//

#import "ZXAlertView.h"

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)
#define FIX(x) (x*(SCREEN_W/375))

@interface ZXAlertView ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *titles;
@end

@implementation ZXAlertView

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message {
    ZXAlertView *view = [[ZXAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        view.title = title;
        view.message = message;
        view.contentWidth = SCREEN_W - FIX(130);
        view.contentMinHeight = 120;
        view.space = 20;
    }
    return view;
}

- (void)fix:(CGFloat)width {
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, _contentWidth, _contentMinHeight);
        _contentView.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
        [self addSubview:_contentView];
        // 毛玻璃
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = _contentView.bounds;
        [_contentView addSubview:blurView];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat width = _contentWidth-2*_space;
        CGFloat height = 0;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        if (_title.length) {
            CGSize size = [_titleLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
            height = size.height;
        }
        _titleLabel.frame = CGRectMake(_space, _space, width, height);
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat width = _contentWidth-2*_space;
        CGFloat y = CGRectGetMaxY(_titleLabel.frame);
        CGFloat height = 0;
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = _message;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        if (_message.length) {
            CGSize size = [_messageLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
            height = size.height;
        }
        if (_title.length) {
            y = CGRectGetMaxY(_titleLabel.frame)+8;
        }
        _messageLabel.frame = CGRectMake(_space, y, width, height);
        [_contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageLabel.frame)+_space, _contentWidth, 40)];
        [_contentView addSubview:_bottomView];
    }
    return _bottomView;
}

- (void)addLineView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentWidth, .5)];
    view.backgroundColor = [UIColor blackColor];
    [_bottomView addSubview:view];
}

- (void)addActionWithTitle:(NSString *)title {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    [_titles addObject:title];
}

- (void)addButtons {
    
    CGFloat width = _contentWidth/_titles.count;
    for (int i=0; i<_titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.frame = CGRectMake(width*i, .5, width, 40-.5);
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bottomView addSubview:button];
    }
}

- (void)updateContentView {
    
    CGFloat height = CGRectGetMaxY(_bottomView.frame);
    _contentView.frame = CGRectMake(0, 0, _contentWidth, height);
    _contentView.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
}

- (void)show {
    [self contentView];
    [self titleLabel];
    [self messageLabel];
    [self bottomView];
    [self addLineView];
    [self addButtons];
    [self updateContentView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hidden {
    
}

@end
