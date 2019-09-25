//
//  YMHandleView.m
//  Review_OC
//
//  Created by Andrew on 2019/3/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMHandleView.h"

@interface YMHandleView () <UIGestureRecognizerDelegate>

/** UIImageView */
@property (nonatomic, weak) UIImageView *imageView;

/** 判断截屏是模糊还是高清 */
@property (nonatomic, assign) BOOL isHighDefinition;

@end

@implementation YMHandleView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
    }
    return self;
}

- (void)setPhotoStyle:(PhotoDefinitionStyle)photoStyle {
    _photoStyle = photoStyle;
    [self setIsHighDefinition];
}

- (void)setIsHighDefinition {
    switch (_photoStyle) {
        case PictureIsBlurry:
        {
            self.isHighDefinition = NO;
            break;
        }
        
        case PictureIsHighDefinition:
        {
            self.isHighDefinition = YES;
            break;
        }
            
        default:
            break;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

- (void)addGes {
    //pan
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageView addGestureRecognizer:pan];
    
    //pinch
    //捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [self.imageView addGestureRecognizer:pinch];
    
    //添加旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [self.imageView addGestureRecognizer:rotation];
    
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageView addGestureRecognizer:longPress];
}

//捏合
- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale);
    //复位
    pinch.scale = 1;
}

//旋转的时候调用
- (void)rotation:(UIRotationGestureRecognizer *)rotation {
    //旋转图片
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotation.rotation);
    
    //复位，只要想相对于上一次旋转就复位
    rotation.rotation = 0;
}

//长按的时候调用
//什么时候调用：长按的时候调用，而且只要手指不离开，拖动的时候会一直调用，手指抬起的时候也会调用
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //设置透明度
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                //对当前的view截屏
                //1.开启一个位图上下文
               /**
                    UIGraphicsBeginImageContext //模糊
                
                ---------------------
                     UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)//原图
                
                     opaque 透明度，不透明设为YES；
                
                     scale  缩放因子，设0时系统自动设置缩放比例图片清晰；设1.0时模糊
                ---------------------
                */
                if (self.isHighDefinition) {
                    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
                } else {
                    UIGraphicsBeginImageContext(self.bounds.size);
                }
                
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ctx];
                
                //从上下文当中生成一张新的图片
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                //调用代理方法
                if ([self.delegate respondsToSelector:@selector(handleView:newImage:)]) {
                    [self.delegate handleView:self newImage:newImage];
                }
                
                //移除当前view
                [self removeFromSuperview];
                
                //关闭上下文
                UIGraphicsEndImageContext();
            }];
        }];
    }
}

//拖动的时候调用
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint transP = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, transP.y);
    //复位
    [pan setTranslation:CGPointZero inView:pan.view];
}

//能够同时支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.bounds;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        _imageView = imageView;
        //添加手势
        [self addGes];
    }
    return _imageView;
}

@end
