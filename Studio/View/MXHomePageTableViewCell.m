//
//  MXHomePageTableViewCell.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/29.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXHomePageTableViewCell.h"
@interface MXHomePageTableViewCell()
@property (nonatomic, strong) UIImageView *studioImageV;
@property (nonatomic, strong) UILabel *studioTitle;
@property (nonatomic, strong) UILabel *studioMessage;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation MXHomePageTableViewCell

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
        make.left.mas_equalTo(weakSelf.mas_left).offset(YMWidth(102));
        make.right.mas_equalTo(weakSelf.mas_right).offset(YMWidth(-YMWidth(10)));
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    _studioTitle.textAlignment = NSTextAlignmentLeft;
    _studioMessage.textAlignment = NSTextAlignmentLeft;
    _studioMessage.numberOfLines = 2;
}
-(void)configInfo:(id)data{
    _model = (MXWorkGoodsModel *)data;
    [_studioImageV sd_setImageWithURL:[NSURL URLWithString:_model.url] placeholderImage:nil];
    _studioTitle.text = _model.title;
    _studioMessage.text = _model.subTitle;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
