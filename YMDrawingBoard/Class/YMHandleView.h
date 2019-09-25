//
//  YMHandleView.h
//  Review_OC
//
//  Created by Andrew on 2019/3/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义截屏是高清还是模糊
typedef enum {
    PictureIsBlurry,//模糊
    PictureIsHighDefinition,//高清
}PhotoDefinitionStyle;

NS_ASSUME_NONNULL_BEGIN

//定义协议
@class YMHandleView;
@protocol HandleViewDelegate <NSObject>

- (void)handleView:(YMHandleView *)handleView newImage:(UIImage *)image;

@end

@interface YMHandleView : UIView

/** 显示图片 */
@property (nonatomic, strong) UIImage *image;
/** 图片样式 */
@property (nonatomic, assign) PhotoDefinitionStyle photoStyle;

//定义代理属性
@property (nonatomic, weak) id <HandleViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
