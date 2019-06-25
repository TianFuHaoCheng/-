//
//  MXStudioNav.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXStudioNav.h"

@implementation MXStudioNav
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    __weak typeof(self)  weakSelf = self;
    weakSelf.backgroundColor = [RGBColorEncapsulation colorWithRGB:0x9B70C2];
    _selectCityBtn = [PC_FactoryUI createButtonWithtitleFont:YMWidth(16) titleColor:WHITE backGroundColor:nil cornerRadius:0 backGroundView:weakSelf title:@"城市 " target:weakSelf Selector:@selector(selectCity) withBlock:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(12);
        make.width.lessThanOrEqualTo(@YMWidth(118));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-14);
    }];
    _selectDepartmentBtn = [PC_FactoryUI createButtonWithtitleFont:YMWidth(16) titleColor:WHITE backGroundColor:nil cornerRadius:0 backGroundView:weakSelf title:@"科室 " target:weakSelf Selector:@selector(selectDepartment) withBlock:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectCityBtn.mas_right).offset(YMWidth(20));
        make.width.lessThanOrEqualTo(@YMWidth(118));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-14);
    }];
    [_selectCityBtn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
    [_selectDepartmentBtn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
    
    
    _selectCityBtn.titleLabel.font = MXFONT_BOLD(16);
    _selectDepartmentBtn.titleLabel.font = MXFONT_BOLD(16);
    
    //改变按钮内部布局 左文字右图
    _selectCityBtn.imageView.contentMode = UIViewContentModeCenter;
    _selectCityBtn.imageView.clipsToBounds = NO;
    _selectDepartmentBtn.imageView.contentMode = UIViewContentModeCenter;
    _selectDepartmentBtn.imageView.clipsToBounds = NO;
    [_selectCityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_selectCityBtn.imageView.size.width, 0, _selectCityBtn.imageView.size.width)];
    [_selectCityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _selectCityBtn.titleLabel.bounds.size.width, 0, -_selectCityBtn.titleLabel.bounds.size.width)];
    [_selectDepartmentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_selectDepartmentBtn.imageView.size.width, 0, _selectDepartmentBtn.imageView.size.width)];
    [_selectDepartmentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _selectDepartmentBtn.titleLabel.bounds.size.width, 0, -_selectDepartmentBtn.titleLabel.bounds.size.width)];
}
#pragma mark --选择城市 选择科室
-(void)selectCity{
    //按钮旋转180度
    _selectCityBtn.imageView.transform = CGAffineTransformRotate(_selectCityBtn.transform, M_PI);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCity)]) {
        [self.delegate selectCity];
    }
}
-(void)selectDepartment{
    //按钮旋转180度
    _selectDepartmentBtn.imageView.transform = CGAffineTransformRotate(_selectDepartmentBtn.transform, M_PI);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectDepartment)]) {
        [self.delegate selectDepartment];
    }
}
//更新约束
-(void)UpdateTheConstraints{
    [_selectCityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_selectCityBtn.imageView.size.width, 0, _selectCityBtn.imageView.size.width)];
    [_selectCityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _selectCityBtn.titleLabel.bounds.size.width, 0, -_selectCityBtn.titleLabel.bounds.size.width)];
    [_selectDepartmentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_selectDepartmentBtn.imageView.size.width, 0, _selectDepartmentBtn.imageView.size.width)];
    [_selectDepartmentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _selectDepartmentBtn.titleLabel.bounds.size.width, 0, -_selectDepartmentBtn.titleLabel.bounds.size.width)];
}
@end
