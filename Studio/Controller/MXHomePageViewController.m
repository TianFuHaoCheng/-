//
//  MXHomePageViewController.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/27.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXHomePageViewController.h"
#import "MXHomePageTableViewCell.h"
#import "MXhomePageTipView.h"
#import "CBSegmentView.h"
#import "MXOrderInfoViewController.h"
#import "MXStudioService.h"
@interface MXHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
@property (nonatomic, strong) MXBaseTableView *myTableView;
@property (nonatomic, strong) MXhomePageTipView *homePageTipView;
@property (nonatomic, strong) CBSegmentView *sliderSegmentView;//全部项目顶部segment
@property (nonatomic, strong) UIView *sliderSegmentBackgroundView;
@property (nonatomic, copy) NSString *categoryId;//品类id 第一次默认为空
@property (nonatomic, strong) NSMutableArray *segmentArr;//导航栏数据源
@property (nonatomic, strong) NSMutableArray *dataArr;//服务列表数据源
@property (nonatomic, assign) BOOL isShowSegment;//是否已经加载了segment

@end

@implementation MXHomePageViewController
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _isShowSegment = NO;
    if (_vcType == 0) {
        [self.view addSubview:self.homePageTipView];
    }
    else{
        [self.view addSubview:self.sliderSegmentBackgroundView];
    }
    [self loadData:YES];
    self.view.backgroundColor = kGrayColor;
    [self.view addSubview:self.myTableView];
}
#pragma mark - < 网络请求 >
-(void)loadData:(BOOL)isRefreshHeader{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_studioModel.Id forKey:@"workId"];
    [params setValue:@(_vcType) forKey:@"edit"];
    [params setValue:_categoryId forKey:@"categoryId"];
    [params setValue:@"2" forKey:@"deviceType"];
    [params setValue:MXUserId forKey:USER_ID];
    [params setValue:@(_page) forKey:@"p"];
    
    [MXStudioService req_workCategoryGoodsListWithParam:params isRefresh:isRefreshHeader Response:^(id response) {
        if (_page == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.segmentArr removeAllObjects];
        //数据容错处理
        if (![MXTool pc_isNullOrNilWithObject:response]) {
            NSDictionary *workGoodsListDic = [response objectForKey:@"workGoodsList"];
            NSArray *productListArr = [response objectForKey:@"productList"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary *productDic in productListArr) {
                MXProductModel *model = [MXProductModel mj_objectWithKeyValues:productDic];
                [self.segmentArr addObject:model];
                [tempArr addObject:model.productTitle];
            }
            if (_isShowSegment == NO && tempArr.count >0) {
                [_sliderSegmentView setTitleArray:tempArr withStyle:CBSegmentStyleSlider];
                _homePageTipView.titleLabel.hidden = NO;
                _homePageTipView.messageLabel.hidden = NO;
                _isShowSegment = YES;
            }
            for (NSDictionary *goodsDic in [workGoodsListDic objectForKey:@"list"]) {
                MXWorkGoodsModel *model = [MXWorkGoodsModel mj_objectWithKeyValues:goodsDic];
                [self.dataArr addObject:model];
            }
            
            BOOL hasNextPage = [[workGoodsListDic objectForKey:@"hasNextPage"] boolValue];
            
            if (!hasNextPage) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [_myTableView.mj_footer endRefreshing];
            }
            [_myTableView.mj_header endRefreshing];
        }else{
            [MBProgressHUD showHUDMsg:[response objectForKey:@"msg"]];
        }
        if (_dataArr.count == 0||_dataArr==nil) {
            
            [self.myTableView showEmptyViewWithType:0];
        }else{
            // 移除无数据占位图
            [self.myTableView removeEmptyView];
        }
        [_myTableView reloadData];
        
    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
        if (_dataArr.count == 0||_dataArr==nil) {
            [self.myTableView showEmptyViewWithType:0];
        }
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    } toView:self.view];
}
#pragma mark --tableView代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  MXWorkGoodsModel *model = self.dataArr[indexPath.row];
  MXOrderInfoViewController *orderInfo = [[MXOrderInfoViewController alloc]init];
  orderInfo.goodsId = model.goodsId;
  orderInfo.workId = model.workId;
  orderInfo.isFromStudio = YES;//是从工作室下的单
  [self.navigationController pushViewController:orderInfo animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YMWidth(120);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MXHomePageTableViewCell *cell = [MXHomePageTableViewCell dequeueReusableCellWithTableView:tableView indexPath:indexPath];
        MXWorkGoodsModel *model = self.dataArr[indexPath.row];
        [cell configInfo:model];
    return cell;
}
#pragma mark -- 上拉加载、下拉刷新
-(void)refreshHeader:(BOOL)isShowProgressHUD{
    if ([MXTool isEmpty:_homePageTipView.messageLabel.text]&&_vcType == 0) {
        _homePageTipView = nil;
        [self.view addSubview:self.homePageTipView];
        //发送通知请求工作室头部信息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getWorkDetails" object:nil];
    }
    _page = 1;
    [self loadData:isShowProgressHUD];
}
-(void)uprefresh{
    _page++;
    [self loadData:NO];
}
#pragma mark - < 懒加载 >
-(MXhomePageTipView *)homePageTipView{
    if (!_homePageTipView) {
        _homePageTipView = [[MXhomePageTipView alloc]initWithFrame:CGRectMake(0, YMWidth(10), swj_screenWidth(), YMWidth(43))];
    }
    return _homePageTipView;
}
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[MXBaseTableView alloc]initWithFrame:CGRectMake(0,YMWidth(53), swj_screenWidth(), swj_screenHeight()-swj_navigationBarHeight()-YMWidth(202)) style:UITableViewStylePlain];
        [MXHomePageTableViewCell registerTableViewCellWithTableView:_myTableView];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        // 无数据占位图点击的回调
        WeakSelf(ws)
        _myTableView.noContentViewTapedBlock = ^{
            [ws refreshHeader:YES];
        };
        if (@available(iOS 11.0,*)) {
            _myTableView.estimatedRowHeight = 0;
            _myTableView.estimatedSectionHeaderHeight = 0;
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _myTableView.estimatedRowHeight = 0;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader:)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 马上进入刷新状态
        _myTableView.mj_header = header;
        // 自定义上拉刷新
        _myTableView.mj_footer = [MXPCFooterRefresh footerWithRefreshingBlock:^{
            //下拉加载更多数据
            [ws uprefresh];
        }];
        
    }
    return _myTableView;
}

-(CBSegmentView *)sliderSegmentView{
    if (!_sliderSegmentView) {
        _sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, YMWidth(4), swj_screenWidth(), YMWidth(43))];
        _sliderSegmentView.backgroundColor =[UIColor clearColor];
        WeakSelf(weakSelf)
        _sliderSegmentView.titleChooseReturn = ^(NSInteger x) {
            MXProductModel *model = weakSelf.segmentArr[x];
            weakSelf.categoryId = model.productId;
            [weakSelf refreshHeader:YES];
        };
    }
    return _sliderSegmentView;
}
-(UIView *)sliderSegmentBackgroundView{
    if (!_sliderSegmentBackgroundView) {
        _sliderSegmentBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, YMWidth(10), swj_screenWidth(), YMWidth(43))];
        _sliderSegmentBackgroundView.backgroundColor = WHITE;
        [MXTool base_viewlayerAddCornerRadi:_sliderSegmentBackgroundView oneCorner:UIRectCornerTopLeft twoCorner:UIRectCornerTopRight radii:YMWidth(30)];
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = kGrayColor;
        [_sliderSegmentBackgroundView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_sliderSegmentBackgroundView);
            make.bottom.mas_equalTo(_sliderSegmentBackgroundView.mas_bottom);
            make.height.mas_equalTo(YMWidth(1));
        }];
        if (!_isShowSegment) {
            [_sliderSegmentBackgroundView addSubview:self.sliderSegmentView];
        }
    }
    return _sliderSegmentBackgroundView;
}
-(NSMutableArray *)segmentArr{
    if (!_segmentArr) {
        _segmentArr = [[NSMutableArray alloc]init];
    }
    return _segmentArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
