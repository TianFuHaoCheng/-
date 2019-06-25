//
//  MXEvaluationSelectView.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/6/11.
//  Copyright © 2019年 MeiXin. All rights reserved.
//

#import "MXEvaluationSelectView.h"
@interface MXEvaluationSelectView()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayMut;
@end
@implementation MXEvaluationSelectView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor = WHITE;
    CGFloat marginX = YMWidth(0);//间距
    CGFloat height = YMWidth(30);
    CGFloat buttonWidth = swj_screenWidth()/5;//每一个按钮宽度
    NSArray * titleArr = @[@"",@"",@"",@"",@"",@""];
    UIButton * markBtn;
    for (int i = 0; i<titleArr.count; i++) {
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!markBtn) {
            tagBtn.frame = CGRectMake(0, 0, buttonWidth, height);
        }else{
            tagBtn.frame = CGRectMake(markBtn.frame.origin.x + markBtn.frame.size.width + marginX, markBtn.frame.origin.y, buttonWidth, height);
            }
        [tagBtn addTarget:self action:@selector(buttonClick:)];
        tagBtn.tag = 1000+i;
        [tagBtn setTitleColor:[RGBColorEncapsulation colorWithRGB:0xF37030] forState:UIControlStateSelected];
        [tagBtn setTitleColor:THEME_MAIN_TITLE_COLOR forState:UIControlStateNormal];
        [tagBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = MXFONT_BOLD(12);
        tagBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        tagBtn.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没用
        if (i==0) {
            tagBtn.selected = YES;
        }
        markBtn = tagBtn;
        [self addSubview:tagBtn];
        [self.arrayMut addObject:tagBtn];
        }

    if (_arrayMut.count <= 0) {
        return;
    }
    UIButton *lastBtn = [self.arrayMut lastObject];
    self.contentSize = CGSizeMake(lastBtn.frame.origin.x+buttonWidth, 0);
}

-(void)buttonClick:(UIButton*)sender{
    for (UIButton *btn in _arrayMut) {
        btn.selected = NO;
    }
    sender.selected = YES;
    //tag 1000全部 1001非常满意 1002满意 1003一般 1004差评 1005恶劣
    NSString *selectLevelStr;
    switch (sender.tag) {
        case 1000:
            selectLevelStr = @"";
            break;
        case 1001:
            selectLevelStr = @"5";
            break;
        case 1002:
            selectLevelStr = @"4";
            break;
        case 1003:
            selectLevelStr = @"3";
            break;
        case 1004:
            selectLevelStr = @"2";
            break;
        case 1005:
            selectLevelStr = @"1";
            break;
        default:
            break;
    }
    
    if (self.evaluationDelegate && [self.evaluationDelegate respondsToSelector:@selector(selectFiltrate:)]) {
        [self.evaluationDelegate selectFiltrate:selectLevelStr];
    }
}
-(void)setEvaluationArr:(NSMutableArray *)evaluationArr{
    _evaluationArr = evaluationArr;
    for (int i=0; i<_arrayMut.count; i++) {
        UIButton *btn = _arrayMut[i];
        [btn setTitle:evaluationArr[i] forState:UIControlStateNormal];
    }
}
-(NSMutableArray *)arrayMut{
    if (!_arrayMut) {
        _arrayMut = [[NSMutableArray alloc]init];
    }
    return _arrayMut;
}
@end
