//
//  ZXAlertView.h
//  ZXAlertView_Example
//
//  Created by 阮巧华 on 2018/11/14.
//  Copyright © 2018 ruanqiaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXAlertView : UIView

typedef void(^ActionBlock)(ZXAlertView *alert);

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentMinHeight;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) CGFloat bottomHeight;

+ (instancetype)alertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;
- (void)addButton:(UIButton *)button block:(ActionBlock)block;
- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
