//
//  MXEvaluationsTableViewCell.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/6/13.
//  Copyright © 2019年 MeiXin. All rights reserved.
//

#import "MXEvaluationsTableViewCell.h"
#import "MXNurseCommend.h"
#import "MXCommentsCollectionViewCell.h"
#import "YPEqualCellSpaceFlowLayout.h"

static NSString *const cellId = @"MXCommentsCollectionViewCell";

@interface MXEvaluationsTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *userImageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *starView;//评分星星
@property (nonatomic, strong) UILabel *satisfactionLabel;//满意度：一般、恶劣、差评....
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *serviceLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray *dataArray;
//@property (nonatomic, strong) UILabel *satisfactionLabel;
@property (nonatomic, assign) CGFloat contentH;
@property (nonatomic, assign) CGFloat collectionViewH;

@end
@implementation MXEvaluationsTableViewCell
+ (instancetype) cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"MXCommentListNewTableViewCell";
    MXEvaluationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MXEvaluationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
        
    }
    return self;
}

- (void)initUI {
    
    self.backgroundColor = WHITE;
    
    self.userImageV.clipsToBounds = YES;
    self.userImageV.layer.cornerRadius = YMWidth(16);
    
    self.nameLabel.textColor = THEME_MAIN_TITLE_COLOR;
    self.nameLabel.font = MXFONT_15;
    
    self.dateLabel.textColor = THEME_SUPPORT_COLOR;
    self.dateLabel.font = MXFONT_12;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    
    self.contentLabel.textColor = THEME_MAIN_TITLE_COLOR;
    self.contentLabel.font = MXFONT_14;
    self.contentLabel.numberOfLines = 0;
    
    self.addressLabel.textColor = THEME_SUPPORT_COLOR;
    self.addressLabel.font = MXFONT_12;
    self.addressLabel.textAlignment = NSTextAlignmentRight;
    
    self.serviceLabel.textColor = THEME_SUPPORT_COLOR;
    self.serviceLabel.font = MXFONT_12;
    self.serviceLabel.textAlignment = NSTextAlignmentRight;
    
    self.lineView.backgroundColor = THEME_LINE_COLOR;
    
    [self.contentView addSubview:self.userImageV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.collectionView];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.serviceLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.lineView];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    
}


- (void)setCommend:(MXNurseCommend *)commend
{
    _commend = commend;
    
    CGFloat spaceX = YMWidth(10);
    CGFloat spaceW = MXScreenW - spaceX * 2;
    
    //标签
    if (![NSString isEmpty:commend.tagValue]) {
        self.dataArray = [NSArray arrayWithArray:[commend.tagValue componentsSeparatedByString:@","]];
        [self.collectionView reloadData];
    }
    
    self.userImageV.frame = CGRectMake(spaceX, YMWidth(15), YMWidth(32), YMWidth(32));
    [self.userImageV sd_setImageWithURL:[NSURL URLWithString:commend.url] placeholderImage:nil];
    self.nameLabel.text = [self getEncryptPhone:commend.userPhone];
    self.nameLabel.frame = CGRectMake(YMWidth(55), YMWidth(15), YMWidth(236), YMWidth(15));
    
    //日期
    NSString *time = [MXTool mxBase_formattedDateDescriptionWithDate:commend.time format:@"yyyy-MM-dd"];
    self.dateLabel.text = time;
    CGFloat dateW = [MXTool sizeWithString:time font:MXFONT_12 maxSize:CGSizeMake(MAXFLOAT, MXFONT_12.lineHeight)].width;
    self.dateLabel.frame = CGRectMake(YMWidth(291), YMWidth(17), dateW, YMWidth(12));
    
    //设置星评
    [self setupStarViewWithLevel:commend];
    self.starView.frame = CGRectMake(YMWidth(55), self.nameLabel.bottom+YMWidth(5), self.userImageV.right+YMWidth(11), YMWidth(12));
    
    //返回高度
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.collectionView.frame = CGRectMake(YMWidth(55), self.starView.bottom+YMWidth(15), swj_screenWidth()-YMWidth(71), height);
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:commend.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [commend.content length])];
    self.contentLabel.attributedText = attributedString;
    CGFloat contentH = [MXTool sizeWithAttributedString:attributedString font:MXFONT_14 maxSize:CGSizeMake(kScreenWidth - YMWidth(71), MAXFLOAT)].height;
    contentH = contentH?contentH:YMWidth(14);
    self.contentLabel.frame = CGRectMake(YMWidth(55), self.collectionView.bottom+YMWidth(10),kScreenWidth - YMWidth(71), contentH);
    
   
    self.addressLabel.text = commend.E_detail_address;
     CGFloat addressLabelW = [MXTool sizeWithString:commend.E_detail_address font:MXFONT_12 maxSize:CGSizeMake(MAXFLOAT, MXFONT_12.lineHeight)].width;
    self.addressLabel.frame = CGRectMake(YMWidth(55), self.contentLabel.bottom+YMWidth(5), addressLabelW, YMWidth(12));
    
    self.serviceLabel.text = commend.goodsName;
    self.serviceLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat serviceR = YMWidth(55)+addressLabelW + YMWidth(10);
    self.serviceLabel.frame= CGRectMake(serviceR, self.contentLabel.bottom+YMWidth(5), MXScreenW - serviceR - YMWidth(16), YMWidth(12));
    self.lineView.frame = CGRectMake(spaceX, self.serviceLabel.bottom + YMWidth(17), spaceW, 1);
    commend.cellHeight = height + contentH + YMWidth(112);
}


#pragma mark -- collectionview delegate &&datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXCommentsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.BGView.backgroundColor = UIColorFromRGBA(0xF36E2D,0.1);
    cell.BGView.layer.borderColor = UIColorFromRGB(0xEB5F1A).CGColor;
    cell.BGView.layer.borderWidth = 0.5;
    cell.BGView.layer.cornerRadius = YMWidth(10);
    cell.BGView.layer.masksToBounds = YES;
    cell.titleLabel.textColor = UIColorFromRGB(0xEB5F1A);
    cell.titleLabel.font = MXFONT_12;
    
    cell.titleLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.dataArray[indexPath.row];
    CGFloat titleW = [MXTool sizeWithString:title font:MXFONT_12 maxSize:CGSizeMake(MAXFLOAT, MXFONT_12.lineHeight)].width;
    return CGSizeMake(titleW + YMWidth(15), YMWidth(20));
}

- (NSString *)getEncryptPhone:(NSString *)phoneStr
{
    if (phoneStr.length!=11) {
        return phoneStr;
    }
    NSString *resultPhoneStr = [NSString stringWithFormat:@"%@****%@",[phoneStr substringToIndex:3],[phoneStr substringFromIndex:7]];
    return resultPhoneStr;
}


#pragma mark -- 设置评价星标
- (void)setupStarViewWithLevel:(MXNurseCommend *)commend
{
    
    CGFloat imageW = 0.0;
    for (int i = 0; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:@"starBackNew"];
        CGFloat imageWH = YMWidth(10);
        imageW += imageWH + YMWidth(4);
        UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake((YMWidth(4) + imageWH) * i,0, imageWH, imageWH)];
        [starView setImage:image];
        [self.starView addSubview:starView];
        if (i < commend.level) {
            UIImage *image = [UIImage imageNamed:@"starFrontNew"];
            starView.image = image;
        }
    }
    commend.showStarView = YES;
    NSString *satisfaction;
    if (commend.level == 5) {
        satisfaction = @"非常满意";
    } else if (commend.level == 4) {
        satisfaction = @"满意";
    } else if (commend.level == 3) {
        satisfaction = @"一般";
    } else if (commend.level == 2) {
        satisfaction = @"差评";
    }  else if (commend.level == 1) {
        satisfaction = @"恶劣";
    }
    if (commend.level==5||commend.level==4||commend.level==3) {
        self.satisfactionLabel.textColor = [RGBColorEncapsulation colorWithRGB:0xF26F76];
    }else{
        self.satisfactionLabel.textColor = [RGBColorEncapsulation colorWithRGB:0xACACAC];
    }
    self.satisfactionLabel.text = satisfaction;
    
    CGFloat satisfactionW = [MXTool sizeWithString:satisfaction font:MXFONT_10 maxSize:CGSizeMake(MAXFLOAT, MXFONT_10.lineHeight)].width;
    self.satisfactionLabel.frame = CGRectMake(imageW + YMWidth(8), 0, satisfactionW, YMWidth(10));
    [self.starView addSubview:_satisfactionLabel];
}

#pragma mark -- lazy
#pragma mark - < 懒加载 >
-(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

-(UIImageView *)userImageV{
    if (!_userImageV) {
        _userImageV = [[UIImageView alloc]init];
    }
    return _userImageV;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
    }
    return _dateLabel;
}

- (UIView *)starView {
    
    if (!_starView) {
        _starView = [[UIView alloc]init];
    }
    return _starView;
}

- (UILabel *)satisfactionLabel {
    if (!_satisfactionLabel) {
        _satisfactionLabel = [[UILabel alloc]init];
        _satisfactionLabel.textColor = THEME_SUPPORT_COLOR;
        _satisfactionLabel.font = MXFONT_10;
    }
    return _satisfactionLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];

    }
    return _contentLabel;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
    }
    return _lineView;
}

-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];

    }
    return _addressLabel;
}

- (UILabel *)serviceLabel {
    if (!_serviceLabel) {
        _serviceLabel = [[UILabel alloc]init];

    }
    return _serviceLabel;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        YPEqualCellSpaceFlowLayout * flowLayout = [[YPEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft scrollDirection:UICollectionViewScrollDirectionVertical LineSpacing:10 InteritemSpacing:10 sectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MXScreenW -YMWidth(71) , 1) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = THEME_BG_COLOR;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

@end
