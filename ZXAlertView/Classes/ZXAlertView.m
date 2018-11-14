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
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *blocks;
@end

@implementation ZXAlertView

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    ZXAlertView *view = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.title = title;
    view.message = message;
    view.contentWidth = SCREEN_W - FIX(130);
    view.contentMinHeight = 120;
    view.space = 20;
    view.bottomHeight = 40;
    return view;
}

- (void)fix:(CGFloat)width {
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _contentView.frame = CGRectMake(0, 0, _contentWidth, _contentMinHeight);
        _contentView.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
        [self addSubview:_contentView];
        // 毛玻璃
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = _contentView.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
        _titleLabel.numberOfLines = 0;
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
            if (_title.length) {
                y = CGRectGetMaxY(_titleLabel.frame)+8;
            }
        }
        _messageLabel.frame = CGRectMake(_space, y, width, height);
        [_contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageLabel.frame)+_space, _contentWidth, _bottomHeight)];
        [_contentView addSubview:_bottomView];
    }
    return _bottomView;
}

- (void)addLineView1 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentWidth, .5)];
    view.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:view];
}

- (void)addLineView2:(CGFloat)x {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, .5, CGRectGetHeight(_bottomView.frame))];
    view.backgroundColor = [UIColor lightGrayColor];
    [_bottomView addSubview:view];
}

- (void)addButton:(id)button block:(ActionBlock)block {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    if (!_blocks) {
        _blocks = [NSMutableArray array];
    }
    [_titles addObject:button];
    [_blocks addObject:block];
}

- (void)addButtons {
    
    CGFloat lineWidth = .5*_titles.count-1;
    CGFloat width = (_contentWidth-lineWidth)/_titles.count;
    for (int i=0; i<_titles.count; i++) {
        UIButton *button = _titles[i];
        button.tag = i;
        button.frame = CGRectMake((width+.5)*i, .5, width, _bottomHeight-.5);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        if (i < _titles.count-1) {
            [self addLineView2:CGRectGetMaxX(button.frame)];
        }
    }
}

- (void)buttonAction:(UIButton *)sender {
    
    ActionBlock block = _blocks[sender.tag];
    if (block) {
        block(self);
    }
}

- (void)updateContentView {
    
    CGFloat height = CGRectGetMaxY(_bottomView.frame);
    if (height > _contentMinHeight) {
        _contentView.frame = CGRectMake(0, 0, _contentWidth, height);
        _contentView.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
    } else {
        CGFloat mY = (_contentMinHeight - height)/2;
        if (_title.length) {
            CGRect frame = _titleLabel.frame;
            frame.origin.y += mY;
            _titleLabel.frame = frame;
        }
        if (_message.length) {
            CGRect frame = _messageLabel.frame;
            frame.origin.y += mY;
            _messageLabel.frame = frame;
        }
        _bottomView.frame = CGRectMake(0, _contentMinHeight-_bottomHeight, _contentWidth, _bottomHeight);
    }
}

- (void)show {
    [self contentView];
    [self titleLabel];
    [self messageLabel];
    [self bottomView];
    [self addLineView1];
    [self addButtons];
    [self updateContentView];
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self];
}

- (void)hidden {
    [self removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"ZXAlertView dealloc");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *view = touches.anyObject.view;
    if (_backgroundTouchHidden && view == self) {
        [self hidden];
    }
}

@end
