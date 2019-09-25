//
//  ViewController.m
//  YMDrawingBoard
//
//  Created by Andrew on 2019/9/25.
//  Copyright © 2019 余默. All rights reserved.
//

#import "ViewController.h"
#import "YMDrawingBoardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)drawingBoradBtnClick:(UIButton *)sender {
    YMDrawingBoardViewController *boardVC = [[YMDrawingBoardViewController alloc] init];
    [self.navigationController pushViewController:boardVC animated:YES];
}

@end
