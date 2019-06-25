//
//  MXStudioMessageViewController.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXStudioMessageViewController.h"
#import "MXStudioMessageHeadView.h"
#import "SJJSegmentView.h"
#import "MXShareSheetView.h"
#import "MXHomePageViewController.h"
#import "MXEvaluationViewController.h"
#import "MXAboutStudiosViewController.h"
#import "MXStudioService.h"
@interface MXStudioMessageViewController ()<UIScrollViewDelegate,MXStudioMessageHeadViewDelegate>
@property (nonatomic, strong) MXStudioMessageHeadView *headView;
@property (nonatomic, strong)SJJSegmentView *segment;//首页 项目 评价
@property (nonatomic, strong)UIScrollView *ctrlContanier;//控制器容器
@property (nonatomic, strong) MXStudioDetailsModel *detailsModel;
@end

@implementation MXStudioMessageViewController
- (BOOL)fd_prefersNavigationBarHidden
{
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_headView) {
        _headView.studioDetailsMode = _detailsModel;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWorkDetails) name:@"getWorkDetails" object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //只有这个方法中拿到了ctrlContanier的frame后才能去设置当前的控制器
    [self scrollViewDidEndScrollingAnimation:self.ctrlContanier];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self createUI];
    //请求工作室头部信息
    [self getWorkDetails:NO];
}
-(void)createUI{
    [self.view addSubview:self.headView];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.ctrlContanier];
    [self createChildCtrls];
    [self makeConstaints];
}
- (void)createChildCtrls
{
    MXHomePageViewController *  homePageVc = [[MXHomePageViewController alloc]init];
    homePageVc.studioModel = _studioModel;
    homePageVc.vcType = 0;
    MXHomePageViewController *  allProjectVc = [[MXHomePageViewController alloc]init];
    allProjectVc.studioModel = _studioModel;
    allProjectVc.vcType = 1;
    MXEvaluationViewController * evaluationVc = [[MXEvaluationViewController alloc]init];
    evaluationVc.studioModel = _studioModel;
    [self addChildViewController:homePageVc];
    [self addChildViewController:allProjectVc];
    [self addChildViewController:evaluationVc];
}

-(void)makeConstaints
{
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(_headView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(swj_screenWidth(), YMWidth(30)));
    }];
    [self.ctrlContanier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.segment.mas_bottom);
    }];
    self.ctrlContanier.contentSize = CGSizeMake(self.childViewControllers.count*swj_screenWidth(), 0);
}
-(void)setNav{
    MXCustomNavBar * nav = [[MXCustomNavBar alloc]initWithFrame:CGRectMake(0, 0, swj_screenWidth(), swj_navigationBarHeight())];
    __weak typeof(self)weakSelf = self;
    nav.title = @"金牌康护";
    [nav.rightItemBtn setImage:[UIImage imageNamed:@"nurseStudioShareBlack"] forState:UIControlStateNormal];
    nav.leftBtnSelect = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    nav.rightBtnSelect = ^{
        [weakSelf goToShare];
    };
    [self.view addSubview:nav];
}
-(void)getWorkDetails{
    [self getWorkDetails:YES];
}
#pragma mark - < 网络请求 >
//请求工作室头部信息
-(void)getWorkDetails:(BOOL)isRefreshfunBtn{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_studioModel.Id forKey:@"workId"];
    [params setValue:@"2" forKey:@"type"];
    [params setValue:MXUserId forKey:USER_ID];
    
    [MXStudioService req_workDetailsWithParam:params isRefresh:isRefreshfunBtn Response:^(id response) {
        //数据容错处理
        if (![MXTool pc_isNullOrNilWithObject:response]) {
            NSDictionary *workDic = [response objectForKey:@"work"];
            _detailsModel = [MXStudioDetailsModel mj_objectWithKeyValues:response];
            _studioModel = [MXStudioModel mj_objectWithKeyValues:workDic];
            _headView.studioDetailsMode = _detailsModel;
        }
    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
    } toView:self.view];
}
//分享按钮
-(void)goToShare{
    if (self.studioModel) {
        
        NSString * urlStr = [NSString stringWithFormat:@"%@studio/HospitalStudio/detail.html?id=%@&type=%@",BASE_WAP_URL,_studioModel.Id,_studioModel.type];
            MXShareSheetView *shareView = [[MXShareSheetView alloc] initWithTitle:_studioModel.name andSubTitle:_studioModel.introduce andUrlStr:urlStr andImg:_headView.studioImageV.image andTypeNo:1 andGoodsID:nil];
            [self presentViewController:shareView animated:YES completion:^{
                
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    //设置optionalNewsSegment滚动到控制器对应的位置
    [self.segment movieToCurrentSelectedSegment:index];
    //容错处理
    if (index<0) return;
    UIViewController * willShowVC;
    if (index == 0) {
        willShowVC = (MXHomePageViewController *)self.childViewControllers[index];
    }else if (index == 1){
        willShowVC = (MXHomePageViewController *)self.childViewControllers[index];
    }else if (index == 2){
        willShowVC = (MXEvaluationViewController *)self.childViewControllers[index];
    }
    //    // 取出需要显示的控制器
    //    ZXLMainController *willShowVC = self.childViewControllers[index];
    //    // 如果当前位置已经显示过了，就直接返回
    if ([willShowVC isViewLoaded]) return;
    // 添加控制器的view到scrollView中;
    willShowVC.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVC.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
-(void)selectfocusOn:(NSString *)follow withButton:(UIButton *)btn{
    WeakSelf(weakSelf)
    [MXTool checkLoginWithPushBlock:^{
        [weakSelf goToFocusON:follow ithButton:btn];
    }];
    
}
-(void)goToFocusON:(NSString *)follow ithButton:(UIButton *)btn{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_studioModel.Id forKey:@"workId"];
    [params setValue:@"1" forKey:@"type"];
    [params setValue:MXUserId forKey:USER_ID];
    [params setValue:follow forKey:@"follow"];
    [MXStudioService req_updateFollowStateWithParam:params Response:^(id response) {
        if ([response boolValue]) {
            MXLog(@"操作成功");
            if ([follow isEqualToString:@"1"]) {
                _detailsModel.isFollow = YES;
            }else{
                _detailsModel.isFollow = NO;
            }
            _headView.studioDetailsMode = _detailsModel;
            [self getWorkDetails:YES];
        }else{
            MXLog(@"操作失败");
        }
    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
    } toView:self.view];
}
//跳转工作室
-(void)didSelectAboutStudio{
    MXAboutStudiosViewController * aboutStudioVc = [[MXAboutStudiosViewController alloc]init];
    aboutStudioVc.studioModel = _studioModel;
    aboutStudioVc.detailsModel = _detailsModel;
    WeakSelf(weakSelf)
    //工作室详情页回调 请求头部信息刷新UI
    aboutStudioVc.callBackBlock = ^(BOOL isSelect) {
        if (isSelect) {
            [weakSelf getWorkDetails:YES];
        }
    };
    [self.navigationController pushViewController:aboutStudioVc animated:YES];
    NSLog(@"我要跳入工作室详情了");
}
#pragma mark - < 懒加载 >
-(MXStudioMessageHeadView *)headView{
    if (_headView == nil) {
        _headView = [[MXStudioMessageHeadView alloc]initWithFrame:CGRectMake(0, swj_navigationBarHeight(), swj_screenWidth(), YMWidth(115))];
        _headView.studioMode = _studioModel;
        _headView.studioDetailsMode = _detailsModel;
        _headView.delegate = self;
        _headView.backgroundColor = kGrayColor;
    }
    return _headView;
}
-(SJJSegmentView *)segment{
    if (!_segment) {
        NSArray * titleArr = @[@"首页",@"全部项目",@"评价"];
        _segment = [[SJJSegmentView alloc] initWithSegmentWithTitleArray:titleArr];
        __weak typeof(self)weakSelf = self;
        _segment.clickSegmentButton = ^(NSInteger index) {
            //点击segment回调
            // 让底部的内容scrollView滚动到对应位置
            CGPoint offset = weakSelf.ctrlContanier.contentOffset;
            offset.x = index * weakSelf.ctrlContanier.frame.size.width;
            [weakSelf.ctrlContanier setContentOffset:offset animated:YES];
        };
    }
    return _segment;
}
-(UIScrollView *)ctrlContanier
{
    if (!_ctrlContanier) {
        _ctrlContanier = [[UIScrollView alloc] init];
        _ctrlContanier.scrollsToTop = NO;
        _ctrlContanier.showsVerticalScrollIndicator = NO;
        _ctrlContanier.showsHorizontalScrollIndicator = NO;
        _ctrlContanier.bounces = NO;//关闭scrollerView 弹簧效果
        _ctrlContanier.pagingEnabled = YES;
        _ctrlContanier.delegate = self;
    }
    return _ctrlContanier;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    //移除所有观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
