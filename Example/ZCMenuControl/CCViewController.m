//
//  CCViewController.m
//  ZCMenuControl
//
//  Created by 1007271253@qq.com on 11/29/2022.
//  Copyright (c) 2022 1007271253@qq.com. All rights reserved.
//

#import "CCViewController.h"
#import "ZCMenuControl.h"
#import "TYDefineConst.h"

@interface CCViewController ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAction {
    CGPoint pt = [self.view convertPoint:self.button.frame.origin toView:kAppWindow];
    pt.y += 54;
    pt.x = (SCREENWIDTH-200)/2 + 100;
    [ZCMenuControl display:@[@"Favorite",@"Delete"] width:88 vertex:pt set:^(ZCMenuControl * _Nonnull menuControl) {
        menuControl.isShowShadow = YES;
        menuControl.topHeight = 2;
        menuControl.rowHeight = 44;
        menuControl.initArrowRect = CGRectMake(65, 0, 10, 6);
    } btnSet:^(NSInteger index, TYButton * _Nonnull itemBtn, UIView * _Nullable line) {
        
    } click:^(NSInteger selectIndex) {
    }];
}


#pragma mark --setter && getter
- (UIButton*)button {
    if (!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake((SCREENWIDTH-200)/2, (SCREENHEIGHT -44)/2, 200, 44);
        [_button setTitle:@"测试" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor blueColor];
        [_button addTarget:self action:@selector(onAction) forControlEvents:UIControlEventTouchUpInside];
        _button.layer.cornerRadius = 4;
    }
    return _button;
}

@end
