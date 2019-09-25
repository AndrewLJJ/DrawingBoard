//
//  YMDrawView.m
//  Review_OC
//
//  Created by Andrew on 2019/3/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMDrawView.h"
#import "YMBezierPath.h"

@interface YMDrawView ()

/** 当前绘制的路径 */
@property (nonatomic, strong) YMBezierPath *path;
/** 保存当前绘制的所有路径 */
@property (nonatomic, strong) NSMutableArray *pathArr;
/** 当前绘制的线宽 */
@property (nonatomic, assign) CGFloat width;
/** 当前绘制的颜色 */
@property (nonatomic, strong) UIColor *color;

@end

@implementation YMDrawView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.width = 1;
    self.color = [UIColor blackColor];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    //获取当前手势所在点
    CGPoint curP = [pan locationInView:self];
    
    //画线
    if (pan.state == UIGestureRecognizerStateBegan) {
        //创建路径
        YMBezierPath *path = [YMBezierPath bezierPath];
        path.lineWidth = self.width;
        self.path = path;
        path.lineJoinStyle = kCGLineJoinRound;//线的样式
        path.lineCapStyle = kCGLineCapRound;//线头的样式
        
        //当发现系统的类，没有办法满足我们的要求时，继承系统类，添加属性满足自己的需求
        //颜色必须得要在drawRect方法中进行绘制
        path.lineColor = self.color;
        
        //设置路径的起点
        [path moveToPoint:curP];
        
        //保存路径
        [self.pathArr addObject:path];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        //添加一根线到当前手指所在的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    //绘制所有路径
    for (YMBezierPath *path in self.pathArr) {
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        } else {
            [path.lineColor set];
            [path stroke];
        }
    }
}

/** 清屏 */
- (void)clear {
    //清空数组，然后重绘
    [self.pathArr removeAllObjects];
    [self setNeedsDisplay];
}

/** 撤销 */
- (void)undo {
    [self.pathArr removeLastObject];
    [self setNeedsDisplay];
}

/** 橡皮檫 */
- (void)erase {
    [self setLineColor:[UIColor whiteColor]];
}

/** 设置线宽 */
- (void)setLineWith:(CGFloat)width {
    self.width = width;
}

/** 设置颜色 */
- (void)setLineColor:(UIColor *)color {
    self.color = color;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.pathArr addObject:image];
    //重绘
    [self setNeedsDisplay];
}

#pragma mark - 懒加载
- (NSMutableArray *)pathArr {
    if (!_pathArr) {
        _pathArr = [NSMutableArray new];
    }
    return _pathArr;
}

@end
