//
//  MXAboutStudioTableViewCell.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/28.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXAboutStudioTableViewCell.h"
@interface MXAboutStudioTableViewCell()
@property (nonatomic, strong) UIView *addressBackgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIImageView *addressImageV;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *callPhoneBtn;
@property (nonatomic, strong) UIView *introBackgroundView;
@property (nonatomic, strong) UILabel *introTitleLabel;
@property (nonatomic, strong) UIView *thirdLineView;
@property (nonatomic, strong) UILabel *introMessageLabel;
@property (nonatomic, strong) UIImageView *noMessageImageV;
@property (nonatomic, strong) UILabel *noMessageNoteLabel;

@end
@implementation MXAboutStudioTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return  self;
}
-(void)createUI{
    self.backgroundColor =kGrayColor;
    
    self.addressBackgroundView.backgroundColor = WHITE;
    self.addressBackgroundView.clipsToBounds = YES;
    self.addressBackgroundView.layer.cornerRadius = YMWidth(15);
    
    self.titleLabel.textColor = THEME_MAIN_TITLE_COLOR;
    self.titleLabel.font = MXFONT_BOLD(16);
    self.titleLabel.text = @"医院地址";
    
    self.addressLabel.textColor = THEME_SUBTITLE_COLOR;
    self.addressLabel.font = MXFONT_14;
    
    self.introBackgroundView.backgroundColor = WHITE;
    self.introBackgroundView.clipsToBounds = YES;
    self.introBackgroundView.layer.cornerRadius = YMWidth(15);
    
    self.introTitleLabel.textColor = THEME_MAIN_TITLE_COLOR;
    self.introTitleLabel.font = MXFONT_BOLD(16);
    self.introTitleLabel.text = @"医院简介";

    
    self.introMessageLabel.textColor = THEME_SUBTITLE_COLOR;
    self.introMessageLabel.font = MXFONT_14;
    
    self.noMessageNoteLabel.textColor = THEME_SUPPORT_COLOR;
    self.noMessageNoteLabel.font = MXFONT_BOLD(14);
    self.noMessageNoteLabel.text = @"未填写医院介绍~";
    
    [self.callPhoneBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];


    [self.contentView addSubview:self.addressBackgroundView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.firstLineView];
    [self.contentView addSubview:self.addressImageV];
    [self.contentView addSubview:self.secondLineView];
    
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.callPhoneBtn];
    [self.contentView addSubview:self.introBackgroundView];
    [self.contentView addSubview:self.introTitleLabel];
    [self.contentView addSubview:self.thirdLineView];
    [self.contentView addSubview:self.introMessageLabel];
    [self.contentView addSubview:self.noMessageImageV];
    [self.contentView addSubview:self.noMessageNoteLabel];


}
//数据源方法
-(void)configInfo:(id)data{
    __weak typeof(self)  weakSelf = self;
    MXAboutStudioModel *myModel = (MXAboutStudioModel *)data;
    _model = myModel;
    CGFloat addressH;
    if ([MXTool isEmpty:_model.address]) {
        addressH = YMWidth(93);
    }else{
        //算出地址的高度
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_model.address];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:2];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_model.address length])];
        self.addressLabel.attributedText = attributedString;
        addressH = [MXTool sizeWithAttributedString:attributedString font:MXFONT_14 maxSize:CGSizeMake(kScreenWidth - YMWidth(119), MAXFLOAT)].height+YMWidth(78);
    }
    [_addressBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(YMWidth(10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(swj_screenWidth()-YMWidth(24), addressH));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(_addressBackgroundView.mas_top).offset(YMWidth(15));
    make.left.mas_equalTo(_addressBackgroundView.mas_left).offset(YMWidth(12));
    }];
    [_firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressBackgroundView.mas_top).offset(YMWidth(45));
        make.left.right.mas_equalTo(_addressBackgroundView);
        make.height.mas_equalTo(YMWidth(1));
    }];
    [_addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_addressBackgroundView.mas_left).offset(YMWidth(12));
    make.top.mas_equalTo(_firstLineView.mas_bottom).offset(YMWidth(12));
    make.size.mas_equalTo(CGSizeMake(YMWidth(22), YMWidth(22)));
    }];
    [_secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(_addressBackgroundView.mas_right).offset(-YMWidth(45));
    make.top.mas_equalTo(_firstLineView.mas_bottom).offset(YMWidth(16));
    make.size.mas_equalTo(CGSizeMake(YMWidth(2), YMWidth(16)));
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_firstLineView.mas_bottom).offset(YMWidth(16));
        make.left.mas_equalTo(_addressImageV.mas_right).offset(YMWidth(8));
        make.right.mas_equalTo(_secondLineView.mas_left).offset(YMWidth(8));
    }];
    _addressLabel.numberOfLines = 0;
    [_callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_secondLineView.mas_right).offset(YMWidth(11));
        make.centerY.mas_equalTo(_addressImageV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(YMWidth(22), YMWidth(22)));
    }];
    CGFloat introH = 0.0;
    if ([MXTool isEmpty:_model.intro]) {
        introH = YMWidth(375);
        _introMessageLabel.hidden = YES;
        _noMessageImageV.hidden = NO;
        _noMessageNoteLabel.hidden = NO;
    }else{
        _introMessageLabel.hidden = NO;
        _noMessageImageV.hidden = YES;
        _noMessageNoteLabel.hidden = YES;
        //算出简介的高度
        NSMutableAttributedString *attributedStringInfo = [[NSMutableAttributedString alloc] initWithString:_model.intro];
        NSMutableParagraphStyle *paragraphStyleInfo = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyleInfo setLineSpacing:2];
        [attributedStringInfo addAttribute:NSParagraphStyleAttributeName value:paragraphStyleInfo range:NSMakeRange(0, [_model.intro length])];
        self.introMessageLabel.attributedText = attributedStringInfo;
        introH = [MXTool sizeWithAttributedString:attributedStringInfo font:MXFONT_14 maxSize:CGSizeMake(kScreenWidth - YMWidth(44), MAXFLOAT)].height+YMWidth(77);
    }
    [_introBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_addressBackgroundView.mas_bottom).offset(YMWidth(10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(YMWidth(351), introH));
    }];
    [_introTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_introBackgroundView.mas_top).offset(YMWidth(15));
        make.left.mas_equalTo(_introBackgroundView.mas_left).offset(YMWidth(12));
    }];
    [_thirdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_introBackgroundView.mas_top).offset(YMWidth(46));
        make.left.right.mas_equalTo(_introBackgroundView);
        make.height.mas_equalTo(YMWidth(1));
    }];
    [_introMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_thirdLineView.mas_bottom).offset(YMWidth(15));
        make.left.mas_equalTo(_introBackgroundView.mas_left).offset(YMWidth(10));
        make.right.mas_equalTo(_introBackgroundView.mas_right).offset(-YMWidth(10));
    }];
    _introMessageLabel.numberOfLines = 0;
    
    [_noMessageImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_thirdLineView.mas_bottom).offset(YMWidth(80));
        make.centerX.mas_equalTo(_introBackgroundView);
        make.size.mas_equalTo(CGSizeMake(YMWidth(280), YMWidth(170)));
    }];
    [_noMessageNoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noMessageImageV.mas_bottom);
        make.centerX.mas_equalTo(_introBackgroundView);
    }];
    _model.cellHeight = introH+addressH+YMWidth(30);
    
}
-(void)callPhone{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCallPhone)]) {
        [self.delegate selectCallPhone];
    }
}
#pragma mark - < 懒加载 >
-(UIView *)addressBackgroundView{
    if (!_addressBackgroundView) {
        _addressBackgroundView = [[UIView alloc]init];
    }
    return _addressBackgroundView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}
-(UIView *)firstLineView{
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc]init];
        _firstLineView.backgroundColor = kGrayColor;
    }
    return _firstLineView;
}
-(UIImageView *)addressImageV{
    if (!_addressImageV) {
        _addressImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dizhi"]];
    }
    return _addressImageV;
}
-(UIView *)secondLineView{
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc]init];
        _secondLineView.backgroundColor = kGrayColor;

    }
    return _secondLineView;
}
-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
    }
    return _addressLabel;
}
-(UIButton *)callPhoneBtn{
    if (!_callPhoneBtn) {
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callPhoneBtn setImage:[UIImage imageNamed:@"Clip2"] forState:UIControlStateNormal];
    }
    return _callPhoneBtn;
}
-(UIView *)introBackgroundView{
    if (!_introBackgroundView) {
        _introBackgroundView = [[UIView alloc]init];
    }
    return _introBackgroundView;
}
-(UILabel *)introTitleLabel{
    if (!_introTitleLabel) {
        _introTitleLabel = [[UILabel alloc]init];
    }
    return _introTitleLabel;
}
-(UIView *)thirdLineView{
    if (!_thirdLineView) {
        _thirdLineView = [[UIView alloc]init];
        _thirdLineView.backgroundColor = kGrayColor;
    }
    return _thirdLineView;
}
-(UILabel *)introMessageLabel{
    if (!_introMessageLabel) {
        _introMessageLabel = [[UILabel alloc]init];
    }
    return _introMessageLabel;
}
-(UIImageView *)noMessageImageV{
    if (!_noMessageImageV) {
        _noMessageImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noIntro"]];
    }
    return _noMessageImageV;
}
-(UILabel *)noMessageNoteLabel{
    if (!_noMessageNoteLabel) {
        _noMessageNoteLabel = [[UILabel alloc]init];
    }
    return _noMessageNoteLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
