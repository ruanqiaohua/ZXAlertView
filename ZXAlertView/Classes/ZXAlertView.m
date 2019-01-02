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
#define Alpha 1.0
#define LineSpacing 6

@interface ZXAlertView ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *blocks;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation ZXAlertView

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    ZXAlertView *view = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.title = title;
    view.message = message;
    view.contentWidth = ceilf(SCREEN_W - FIX(130));
    view.contentMinHeight = 140;
    view.space = 20;
    view.bottomHeight = 45;
    view.lineHeight = 0.5;
    return view;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
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

- (UIView *)messageView {
    if (!_messageView) {
        _messageView = [[UIView alloc] init];
        _messageView.backgroundColor = [UIColor colorWithWhite:1 alpha:Alpha];
        _messageView.frame = CGRectMake(0, 0, _contentWidth, _contentMinHeight-_bottomHeight-_lineHeight);
        [_contentView addSubview:_messageView];
//        [self addBlurView:_messageView];
    }
    return _messageView;
}

- (void)addBlurView:(UIView *)view {
    
    // 毛玻璃
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:blurView];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat width = floorf(_contentWidth-2*_space);
        CGFloat height = 0;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        if (_title.length) {
            height = [self setLabel:_titleLabel text:_title];
        }
        _titleLabel.frame = CGRectMake(_space, _space, width, height);
        [_messageView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat width = _contentWidth-2*_space;
        CGFloat y = CGRectGetMaxY(_titleLabel.frame);
        CGFloat height = 0;
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor colorWithRed:62.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
        if (_meessageAttributedString) {
            height = [self setLabel:_messageLabel attributedString:_meessageAttributedString];
            if (_title.length) {
                y = CGRectGetMaxY(_titleLabel.frame)+8;
            }
        } else if (_message.length) {
            height = [self setLabel:_messageLabel text:_message];
            if (_title.length) {
                y = CGRectGetMaxY(_titleLabel.frame)+8;
            }
        }
        _messageLabel.frame = CGRectMake(_space, y, width, height);
        [_messageView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageView.frame)+_lineHeight, _contentWidth, _bottomHeight)];
        [_contentView addSubview:_bottomView];
    }
    return _bottomView;
}

- (void)addLineView1 {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentWidth, _lineHeight)];
    view.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    [_bottomView addSubview:view];
}

- (void)addLineView2:(CGFloat)x {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, _lineHeight, CGRectGetHeight(_bottomView.frame))];
    view.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    [_bottomView addSubview:view];
}

- (void)addButton:(id)button block:(ZXActionBlock)block {
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
    
    CGFloat lineWidth = _lineHeight*(_titles.count-1);
    CGFloat width = ceilf(_contentWidth-lineWidth)/_titles.count;
    for (int i=0; i<_titles.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:Alpha];
        view.frame = CGRectMake((width+_lineHeight)*i, 0, width, _bottomHeight);
        UIButton *button = _titles[i];
        button.tag = i;
        button.frame = view.bounds;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:view];
        [view addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)sender {
    
    ZXActionBlock block = _blocks[sender.tag];
    if (block) {
        block(self);
    }
}

- (void)updateMessageView {
    _messageView.frame = CGRectMake(0, 0, _contentWidth, CGRectGetMaxY(_messageLabel.frame)+_space);
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
        _messageView.frame = CGRectMake(0, 0, _contentWidth, _contentMinHeight-_bottomHeight-_lineHeight);
        _bottomView.frame = CGRectMake(0, _contentMinHeight-_bottomHeight, _contentWidth, _bottomHeight);
    }
}

- (void)show {
    [self contentView];
    [self messageView];
    [self titleLabel];
    [self messageLabel];
    [self updateMessageView];
    [self bottomView];
    [self addButtons];
    [self updateContentView];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _window.windowLevel = UIWindowLevelAlert;
    [_window addSubview:self];
    [_window makeKeyAndVisible];
}

- (void)hidden {
    _blocks = nil;
    _window.hidden = YES;
    _window = nil;
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

- (CGFloat)setLabel:(UILabel *)label text:(NSString *)string {
    if (!string || !label) {
        return 0;
    }
    UIFont *font = label.font;
    UIColor *color = label.textColor;
    CGFloat textWidth = _contentWidth-2*_space;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    if (font.pointSize*string.length > textWidth) {
        paragraphStyle.lineSpacing = LineSpacing;
    }
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle,
                                 NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: color};
    label.attributedText = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    CGFloat height = [label sizeThatFits:CGSizeMake(textWidth, MAXFLOAT)].height;
    return ceilf(height)+1;
}

- (CGFloat)setLabel:(UILabel *)label attributedString:(NSMutableAttributedString *)attributedString {
    
    if (!attributedString || !label) {
        return 0;
    }
    CGFloat textWidth = _contentWidth-2*_space;
    label.attributedText = attributedString;
    CGFloat height = [label sizeThatFits:CGSizeMake(textWidth, MAXFLOAT)].height;
    return ceilf(height)+1;
}

+ (UIButton *)cancelButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:62.0f/255.0f green:62.0f/255.0f blue:62.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)sureButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:142.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)knowButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:195.0f/255.0f green:142.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    return button;
}

@end
