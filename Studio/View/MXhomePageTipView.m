//
//  MXhomePageTipView.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/27.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXhomePageTipView.h"
@interface MXhomePageTipView()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MXhomePageTipView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    __weak typeof(self)  weakSelf = self;
    self.backgroundColor=kGrayColor;
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, swj_screenWidth(), YMWidth(42))];
    _backgroundView.backgroundColor = WHITE;
    [self addSubview:_backgroundView];
    
    [MXTool base_viewlayerAddCornerRadi:_backgroundView oneCorner:UIRectCornerTopLeft twoCorner:UIRectCornerTopRight radii:YMWidth(30)];

    _titleLabel = [PC_FactoryUI createLabelWithtextFont:YMWidth(14) textColor:[RGBColorEncapsulation colorWithRGB:0xF37030] backGroundView:_backgroundView text:@"特色服务" withBlock:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(YMWidth(12));
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(15));
    }];
    _messageLabel = [PC_FactoryUI createLabelWithtextFont:YMWidth(12) textColor:[RGBColorEncapsulation colorWithRGB:0xE42314] backGroundView:_backgroundView text:[self getTipStr] withBlock:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(-YMWidth(12));
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(16));
    }];
    _lineView = [PC_FactoryUI createViewWithColor:kGrayColor cornerRadius:0 superView:weakSelf andBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundView.mas_bottom);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(YMWidth(1));
    }];
    //容错处理 如果messageLabel.text为nil的话，进行富文本操作会crash
    if (![MXTool isEmpty:_messageLabel.text]) {
        _messageLabel.attributedText = [RichText normalStr:_messageLabel.text AndRichStr:@"最近可约" color:0x000000 Andalpha:1];
    }
    _titleLabel.hidden = YES;
    _messageLabel.hidden = YES;
}
-(NSString *)getTipStr{
    NSString *tipStr;
    if ([MXTool isBetweenFromHour:0 toHour:6]) {
        tipStr = @"最近可约 今天09:00";
    }else if ([MXTool isBetweenFromHour:6 toHour:7]){
        tipStr = @"最近可约 今天10:00";
    }else if ([MXTool isBetweenFromHour:7 toHour:8]){
        tipStr = @"最近可约 今天11:00";
    }else if ([MXTool isBetweenFromHour:8 toHour:9]){
        tipStr = @"最近可约 今天12:00";
    }else if ([MXTool isBetweenFromHour:9 toHour:10]){
        tipStr = @"最近可约 今天13:00";
    }else if ([MXTool isBetweenFromHour:10 toHour:11]){
        tipStr = @"最近可约 今天14:00";
    }else if ([MXTool isBetweenFromHour:11 toHour:12]){
        tipStr = @"最近可约 今天15:00";
    }else if ([MXTool isBetweenFromHour:12 toHour:13]){
        tipStr = @"最近可约 今天16:00";
    }else if ([MXTool isBetweenFromHour:13 toHour:14]){
        tipStr = @"最近可约 今天17:00";
    }else if ([MXTool isBetweenFromHour:14 toHour:15]){
        tipStr = @"最近可约 今天18:00";
    }else if ([MXTool isBetweenFromHour:15 toHour:16]){
        tipStr = @"最近可约 今天19:00";
    }else if ([MXTool isBetweenFromHour:16 toHour:17]){
        tipStr = @"最近可约 今天20:00";
    }else if ([MXTool isBetweenFromHour:17 toHour:18]){
        tipStr = @"最近可约 今天21:00";
    }else if ([MXTool isBetweenFromHour:18 toHour:24]){
        tipStr = @"最近可约 明天09:00";
    }
    return tipStr;
}
@end
