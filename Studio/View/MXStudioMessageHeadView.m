//
//  MXStudioMessageHeadView.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXStudioMessageHeadView.h"

@implementation MXStudioMessageHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    __weak typeof(self) weakSelf = self;
    weakSelf.backgroundColor = WHITE;
    UITapGestureRecognizer *integralTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboutStudio)];
    [weakSelf addGestureRecognizer:integralTapGes];
    _studioImageV = [PC_FactoryUI createImageViewWithView:weakSelf cornerRadius:YMWidth(8) imageName:@"" andMasoryBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(16));
        make.left.mas_equalTo(weakSelf.mas_left).offset(YMWidth(12));
        make.size.mas_equalTo(CGSizeMake(YMWidth(60), YMWidth(60)));
    }];
    _studioImageV.layer.borderWidth = YMWidth(1);
    _studioImageV.layer.borderColor = [RGBColorEncapsulation colorWithRGB:0x000000 alpha:0.1].CGColor;
    _studioImageV.contentMode = UIViewContentModeScaleAspectFill;
    _studioTitle = [PC_FactoryUI createLabelWithtextFont:YMWidth(18) textColor:THEME_MAIN_TITLE_COLOR backGroundView:weakSelf text:@"" withBlock:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_studioImageV.mas_right).offset(YMWidth(11));
        make.top.mas_equalTo(_studioImageV.mas_top).offset(YMWidth(5));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-YMWidth(113));
    }];
    _studioTitle.font = MXFONT_BOLD(18);
    _studioTitle.numberOfLines = 2;
    
    _focusOnBtn = [PC_FactoryUI createButtonWithtitleFont:0 titleColor:nil backGroundColor:nil cornerRadius:0 backGroundView:weakSelf title:@"" target:self Selector:@selector(focusOn:) withBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_studioImageV.mas_top).offset(YMWidth(5));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-YMWidth(8));
        make.size.mas_equalTo(CGSizeMake(YMWidth(66), YMWidth(24)));
    }];
    _businessHours = [PC_FactoryUI createLabelWithtextFont:YMWidth(12) textColor:THEME_SUBTITLE_COLOR backGroundView:weakSelf text:@"服务时间  09:00-21:00" withBlock:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(YMWidth(12));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-YMWidth(15));
    }];
    
    _fansCountLabel = [PC_FactoryUI createLabelWithtextFont:0  textColor:THEME_SUBTITLE_COLOR backGroundView:weakSelf text:@"0" withBlock:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(-YMWidth(12));
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(76));
    }];
    _fansCountLabel.font = MXFONT_BOLD(14);
    
    _fansCountBtn = [PC_FactoryUI createButtonWithtitleFont:YMWidth(10) titleColor:THEME_SUBTITLE_COLOR backGroundColor:nil cornerRadius:0 backGroundView:weakSelf title:@"粉丝" target:self Selector:@selector(fansCount) withBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_fansCountLabel.mas_bottom);
        make.centerX.mas_equalTo(_fansCountLabel);
        make.size.mas_equalTo(CGSizeMake(YMWidth(20), YMWidth(10)));
    }];

    _lineView = [PC_FactoryUI createViewWithColor:[RGBColorEncapsulation colorWithRGB:0x000000 alpha:0.1] cornerRadius:0 superView:weakSelf andBlock:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_fansCountLabel.mas_left).offset(-YMWidth(15));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-YMWidth(15));
        make.size.mas_equalTo(CGSizeMake(YMWidth(0.5), YMWidth(22)));
    }];
    
    _nurseCountLabel = [PC_FactoryUI createLabelWithtextFont:0  textColor:THEME_SUBTITLE_COLOR backGroundView:weakSelf text:@"0" withBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(76));
        make.right.mas_equalTo(_lineView.mas_left).offset(-YMWidth(15));
    }];
    _nurseCountLabel.font = MXFONT_BOLD(14);
    
    _nurseCountBtn = [PC_FactoryUI createButtonWithtitleFont:YMWidth(10) titleColor:THEME_SUBTITLE_COLOR backGroundColor:nil cornerRadius:0 backGroundView:weakSelf title:@"护士" target:self Selector:@selector(nurseCount) withBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nurseCountLabel.mas_bottom);
        make.centerX.mas_equalTo(_nurseCountLabel);
        make.size.mas_equalTo(CGSizeMake(YMWidth(20), YMWidth(10)));
    }];
    
    
}
//关注、取消关注点击事件
-(void)focusOn:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectfocusOn:withButton:)]) {
        NSString *follow;
        if ([sender.titleLabel.text isEqualToString:@"关注"]) {
            follow = @"2";
        }else{
            follow = @"1";
        }
        [self.delegate selectfocusOn:follow withButton:sender];
    }
}
//点击跳入工作室详情
-(void)aboutStudio{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAboutStudio)]) {
        [self.delegate didSelectAboutStudio];
    }
}
//护士数量点击事件
-(void)nurseCount{
    
}
//粉丝数量点击事件
-(void)fansCount{
    
}
-(void)setStudioMode:(MXStudioModel *)studioMode{
    [_studioImageV sd_setImageWithURL:[NSURL URLWithString:studioMode.workImg] placeholderImage:nil];
    _studioTitle.text = studioMode.name;
}
-(void)setStudioDetailsMode:(MXStudioDetailsModel *)studioDetailsMode{
    NSString *workSumStr;
    NSString *fans;
    if (studioDetailsMode.workSum>0) {
        workSumStr = [NSString stringWithFormat:@"%ld",(long)studioDetailsMode.workSum];
    }else{
        workSumStr = @"0";
    }
    if (studioDetailsMode.fans>0) {
        fans = [NSString stringWithFormat:@"%ld",(long)studioDetailsMode.fans];
    }else{
        fans = @"0";
    }
    _nurseCountLabel.text = workSumStr;
    _fansCountLabel.text = fans;
    if (studioDetailsMode.isFollow) {
        [_focusOnBtn setImage:[UIImage imageNamed:@"focusOff"] forState:UIControlStateNormal];
        [_focusOnBtn setTitle:@"关注" forState:UIControlStateNormal];
    }else{
        [_focusOnBtn setImage:[UIImage imageNamed:@"focusOn"] forState:UIControlStateNormal];
        [_focusOnBtn setTitle:@"未关注" forState:UIControlStateNormal];
    }
    
}
@end
