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

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentMinHeight;
@property (nonatomic, assign) CGFloat space;

+ (id)alertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;
- (void)addActionWithTitle:(NSString *)title;
- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
