//
//  MXStudioTableViewCell.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXStudioTableViewCell.h"

@implementation MXStudioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        
    }
    return  self;
}
-(void)createUI{
    __weak typeof(self) weakSelf = self;
    weakSelf.backgroundColor = WHITE;
    
    _studioImageV = [PC_FactoryUI AtCellcreateImageViewWithView:weakSelf cornerRadius:YMWidth(8) imageName:@"" andMasoryBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(20));
        make.left.mas_equalTo(weakSelf.mas_left).offset(YMWidth(12));
        make.size.mas_equalTo(CGSizeMake(YMWidth(80), YMWidth(80)));
    }];
    _studioImageV.layer.borderWidth = YMWidth(1);
    _studioImageV.layer.borderColor = [RGBColorEncapsulation colorWithRGB:0x000000 alpha:0.1].CGColor;
  
    //按原图比例进行拉伸，是图片完全展示在bouns中
    _studioImageV.contentMode = UIViewContentModeScaleAspectFill;
  
  
    _studioTitle = [PC_FactoryUI AtCellcreateLabelWithtextFont:YMWidth(16) textColor:THEME_MAIN_TITLE_COLOR backGroundView:weakSelf text:@"" withBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_studioImageV.mas_top).offset(YMWidth(12));
        make.left.mas_equalTo(_studioImageV.mas_right).offset(YMWidth(10));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-YMWidth(20));
    }];
    _studioTitle.font = MXFONT_BOLD(16);
    _studioMessage = [PC_FactoryUI AtCellcreateLabelWithtextFont:YMWidth(12) textColor:THEME_SUBTITLE_COLOR backGroundView:weakSelf text:@"" withBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_studioTitle.mas_bottom).offset(YMWidth(6));
        make.left.mas_equalTo(_studioTitle.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-YMWidth(14));
    }];
    _lineView = [PC_FactoryUI AtCellcreateViewWithColor:kGrayColor cornerRadius:0 superView:weakSelf andBlock:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(YMWidth(12));
        make.right.mas_equalTo(weakSelf.mas_right).offset(YMWidth(-YMWidth(12)));
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    _kindBackgroundImageV = [PC_FactoryUI AtCellcreateImageViewWithView:weakSelf cornerRadius:0 imageName:@"Rectangles" andMasoryBlock:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(12));
        make.right.mas_equalTo(weakSelf.mas_right).offset(-YMWidth(3));
        make.size.mas_equalTo(CGSizeMake(YMWidth(51), YMWidth(51)));
    }];
    _studioTitle.textAlignment = NSTextAlignmentLeft;
    _studioMessage.textAlignment = NSTextAlignmentLeft;
    _studioMessage.numberOfLines = 2;
    _studioKind = [PC_FactoryUI createLabelWithtextFont:YMWidth(10) textColor:WHITE backGroundView:_kindBackgroundImageV text:@"" withBlock:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(_kindBackgroundImageV.mas_top).offset(YMWidth(24));
        make.centerX.mas_equalTo(_kindBackgroundImageV);
    }];
    _kindBackgroundImageV.transform =CGAffineTransformMakeRotation(M_PI_4);
}
//数据源方法
-(void)configInfo:(id)data{
    _model = (MXStudioModel *)data;
    [_studioImageV sd_setImageWithURL:[NSURL URLWithString:_model.workImg] placeholderImage:nil];
    _studioTitle.text = _model.name;
    _studioMessage.text = _model.introduce;
    
    if ([_model.type isEqualToString:@"1"]) {
        if ([MXTool isEmpty:_model.departmentName]) {
            _kindBackgroundImageV.hidden = YES;
        }else{
            _kindBackgroundImageV.hidden = NO;
        }
        if (_model.departmentName.length>2) {
            _studioKind.font = [UIFont systemFontOfSize:YMWidth(10)];
        }else{
            _studioKind.font = [UIFont systemFontOfSize:YMWidth(12)];
        }
        _studioKind.text = _model.departmentName;
    }else{
            _kindBackgroundImageV.hidden = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
