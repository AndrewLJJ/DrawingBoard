//
//  YMDrawingBoardViewController.m
//  Review_OC
//
//  Created by Andrew on 2019/3/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMDrawingBoardViewController.h"
#import "YMDrawView.h"
#import "YMHandleView.h"

@interface YMDrawingBoardViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,HandleViewDelegate>
//画板
@property (weak, nonatomic) IBOutlet YMDrawView *drawView;

@end

@implementation YMDrawingBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 按钮监听事件
/** 清屏 */
- (IBAction)clsBtnClick {
    [self.drawView clear];
}

/** 撤销 */
- (IBAction)revocationBtnClick {
    [self.drawView undo];
}

/** 橡皮擦 */
- (IBAction)eraserBtnClick {
    [self.drawView erase];
}

/** 照片 */
- (IBAction)photoBtnClick {
    
    //弹出系统相册，从中选择一张照片，把照片绘制到画板
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    //设置照片的来源
    pickVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    pickVC.delegate = self;
    
    [self presentViewController:pickVC animated:YES completion:nil];
}

//选择照片完毕后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    YMHandleView *handleView = [[YMHandleView alloc] initWithFrame:self.drawView.frame];
    handleView.backgroundColor = [UIColor clearColor];
    handleView.image = image;
    handleView.photoStyle = PictureIsHighDefinition;
    //遵守协议
    handleView.delegate = self;
    [self.view addSubview:handleView];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//调用代理方法
- (void)handleView:(YMHandleView *)handleView newImage:(UIImage *)image {
    self.drawView.image = image;
}


/** 保存 */
- (IBAction)saveBtnClick {

    [UIView animateWithDuration:0.25 animations:^{
        self.drawView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.drawView.alpha = 1;
        } completion:^(BOOL finished) {
            //对画板做截屏
            
//            UIGraphicsBeginImageContext(self.drawView.bounds.size);//模糊
            UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0.0);//原图
            
            //把View的layer的内容渲染到上下文当中
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            [self.drawView.layer renderInContext:ctx];
            
            //从上下文当中生成一张图片
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            //关闭上下文
            UIGraphicsEndImageContext();
            
            //把生成的图片保存到系统相册中
            //保存完毕时调用的方法必须得是：image:didFinishSavingWithError:contextInfo:
            UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"%@",contextInfo);
}

//线宽
- (IBAction)lineWith:(UISlider *)sender {
    [self.drawView setLineWith:sender.value];
}

//设置线颜色
- (IBAction)setLineColorBtnClick:(UIButton *)sender {
    [self.drawView setLineColor:sender.backgroundColor];
}



@end
