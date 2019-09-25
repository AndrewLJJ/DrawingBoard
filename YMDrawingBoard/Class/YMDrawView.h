//
//  YMDrawView.h
//  Review_OC
//
//  Created by Andrew on 2019/3/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMDrawView : UIView

/** 要绘制的图片 */
@property (nonatomic, strong) UIImage *image;

/** 清屏 */
- (void)clear;

/** 撤销 */
- (void)undo;

/** 橡皮檫 */
- (void)erase;

/** 设置线宽 */
- (void)setLineWith:(CGFloat)width;

/** 设置颜色 */
- (void)setLineColor:(UIColor *)color;


@end

NS_ASSUME_NONNULL_END
