//
//  MXStudioViewController.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXStudioViewController.h"
#import "MXStudioNav.h"
#import "MXStudioTableViewCell.h"
#import "MXStudioMessageViewController.h"
#import "MXCityAleartView.h"
#import "MXNurseMeunView.h"
#import "MXMeunView.h"
#import "MXCityModel.h"
#import "MXStudioModel.h"
#import "MXLoginNewViewController.h"
#import "MXStudioService.h"
@interface MXStudioViewController ()<UITableViewDelegate,UITableViewDataSource,MXStudioNavDelegate>
{
    int _page;//请求页数
}
@property (nonatomic, strong) MXStudioNav *navView;//自定义导航栏
@property (nonatomic, strong) MXBaseTableView *studioTableView;
@property (nonatomic, strong) MXCityAleartView *cityAleartView;//城市弹出视图
@property (nonatomic, strong) MXMeunView *menuDataView;//科室弹出视图
@property (nonatomic, assign) BOOL isShowCity;
@property (nonatomic, assign) BOOL isShowDepartment;
@property (nonatomic, strong) MXStudioDepartmentModel *departmentModel;//科室模型
@property (nonatomic, strong) NSMutableDictionary *params;//请求科室列表形参
@property (nonatomic, strong) NSArray *departmentNameArray;//科室名称数据模型集合
@property (nonatomic, strong) NSMutableArray *departmentListArr;//科室列表数据模型
@property (nonatomic, strong) MXEmptyTipView *emptyView;//无网占位图
@property (nonatomic, copy) NSString *cityName;//城市名称

@end

@implementation MXStudioViewController
//隐藏系统导航条
- (BOOL)fd_prefersNavigationBarHidden
{
  return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isShowCity = NO;
    _isShowDepartment = NO;
    _page = 1;
    //默认取到定位城市
    _cityName = [MXSingleton sharedInstance].cityName;
    [self createUI];
    //数据请求
    [self getDepartmentList:YES];
}
-(void)setNav{
    [self.view addSubview:self.navView];
}
-(void)createUI{
    if (!ObtainAppDelegate.isReachable) {
        //没有网加载无网络页面
        [self.view addSubview:self.emptyView];
        _emptyView.hidden = NO;
    }else{
        //有网隐藏无网络页面添加tableview
        _emptyView.hidden = YES;
        [self setNav];
        [self.view addSubview:self.studioTableView];
    }
}
#pragma mark - < 网络请求 >
//获取工作室title信息
- (void)getDepartment
{
    [MXStudioService req_workDepartmentListWithParam:nil Response:^(id response) {
        self.departmentNameArray = [MXStudioDepartmentModel mj_objectArrayWithKeyValuesArray:response[@"list"]];
        self.menuDataView.dataArray = self.departmentNameArray;
    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
    } toView:self.view];
}
//根据工作室名称获取对应的工作室列表
-(void)getDepartmentList:(BOOL)isRefreshHeader{
    
    [self.params setValue:_cityName forKey:@"city"];
    [self.params setValue:_departmentModel.departmentId forKey:@"departmentId"];
    [self.params setValue:MXUserId forKey:USER_ID];
    [self.params setValue:@(_page) forKey:@"p"];
    [MXStudioService req_workListWithParam:_params isRefresh:isRefreshHeader Response:^(id response) {
        if (_page == 1) {
            [self.departmentListArr removeAllObjects];
        }
        NSDictionary *jsonData = [response objectForKey:@"result"];
        NSArray * listArr;
        //数据容错处理
        if (![MXTool pc_isNullOrNilWithObject:jsonData]) {
            listArr = [jsonData objectForKey:@"list"];
            for (NSDictionary *dataDic in listArr) {
                MXStudioModel * model = [MXStudioModel mj_objectWithKeyValues:dataDic];
                [self.departmentListArr addObject:model];
            }
            BOOL hasNextPage = [[jsonData objectForKey:@"hasNextPage"] boolValue];
            if (!hasNextPage) {
                [_studioTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [_studioTableView.mj_footer endRefreshing];
            }
            [_studioTableView.mj_header endRefreshing];
        }
        if (listArr.count == 0||listArr==nil) {
            //数据为空展示空页面
            [self.studioTableView showEmptyViewWithType:0];
        }else{
            // 移除无数据占位图
            [self.studioTableView removeEmptyView];
        }
        [_studioTableView reloadData];
    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
        if (_departmentListArr.count == 0||_departmentListArr==nil) {
            [self.studioTableView showEmptyViewWithType:0];
        }
        [_studioTableView.mj_header endRefreshing];
        [_studioTableView.mj_footer endRefreshingWithNoMoreData];
    } toView:self.view];
}
#pragma mark --tableView代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //新登录临时入口
//    MXLoginNewViewController * messageVc = [[MXLoginNewViewController alloc]init];
//    [self presentViewController:messageVc animated:YES completion:nil];
    
    MXStudioMessageViewController * messageVc = [[MXStudioMessageViewController alloc]init];
    messageVc.studioModel = self.departmentListArr[indexPath.row];
    [self.navigationController pushViewController:messageVc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YMWidth(120);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.departmentListArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MXStudioTableViewCell *cell = [MXStudioTableViewCell dequeueReusableCellWithTableView:tableView indexPath:indexPath];
    MXStudioModel *model  = self.departmentListArr[indexPath.row];
    [cell configInfo:model];
    return cell;
}
//导航栏按钮代理方法
-(void)selectCity{
    __weak typeof(self)  weakSelf = self;
    //如果这个时候科室是展开的
    if (_isShowDepartment) {
        _menuDataView.isHidden = YES;
        self.navView.selectDepartmentBtn.imageView.transform = CGAffineTransformIdentity;
        _isShowDepartment = NO;
    }
    if (_isShowCity) {
     _cityAleartView.frame = CGRectMake(0, 0, -swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight(), swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight());
        _isShowCity =NO;
        self.navView.selectCityBtn.imageView.transform = CGAffineTransformIdentity;
        return;
    }
    if (!_cityAleartView) {
        _cityAleartView  = [[MXCityAleartView alloc]initWithFrame:CGRectMake(0, swj_navigationBarHeight(), swj_screenWidth(), swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight())];
        [self.view addSubview:_cityAleartView];
    }else{
        [_cityAleartView removeFromSuperview];
        
        _cityAleartView  = [[MXCityAleartView alloc]initWithFrame:CGRectMake(0, swj_navigationBarHeight(), swj_screenWidth(), swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight())];
        [self.view addSubview:_cityAleartView];
    }
    _isShowCity =YES;
    _cityAleartView.MXSelectCityBlock = ^(MXCityModel *cityModel) {
        _cityName = cityModel.name;
        weakSelf.cityAleartView.frame = CGRectMake(0, 0, -swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight(), swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight());
        [weakSelf.navView.selectCityBtn setTitle:[NSString stringWithFormat:@"%@ ",cityModel.name]  forState:UIControlStateNormal];
        [weakSelf.navView UpdateTheConstraints];
        weakSelf.isShowCity = NO;
        weakSelf.navView.selectCityBtn.imageView.transform = CGAffineTransformIdentity;
        [weakSelf refreshHeader:YES];
    };
}
//科室点击事件
-(void)selectDepartment{
    if (_isShowCity) {
        _cityAleartView.frame = CGRectMake(0, 0, -swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight(), swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight());
        _isShowCity =NO;
        self.navView.selectCityBtn.imageView.transform = CGAffineTransformIdentity;
    }
    if (_isShowDepartment) {
        _menuDataView.isHidden = YES;
        self.navView.selectDepartmentBtn.imageView.transform = CGAffineTransformIdentity;
        _isShowDepartment = NO;
    }else{
        [self getDepartment];
        [self.view insertSubview:self.menuDataView aboveSubview:_studioTableView];
        _isShowDepartment = YES;
    }
    
}
#pragma mark -- 上拉加载、下拉刷新
-(void)refreshHeader:(BOOL)isRefreshHeader{
    _page = 1;
    [self getDepartmentList:isRefreshHeader];
}
-(void)uprefresh{
    _page++;
    [self getDepartmentList:NO];
}
#pragma mark - < 懒加载 >
-(MXStudioNav *)navView{
    if (_navView == nil) {
        _navView = [[MXStudioNav alloc]initWithFrame:CGRectMake(0, 0, swj_screenWidth(), swj_navigationBarHeight())];
        //科室隐藏掉
        _navView.selectDepartmentBtn.hidden =YES;
        _navView.delegate = self;
        if (_cityName.length > 0) {
        [_navView.selectCityBtn setTitle:[NSString stringWithFormat:@"%@ ",_cityName]  forState:UIControlStateNormal];
        [_navView UpdateTheConstraints];
        }
        
    }
    return _navView;
}
-(UITableView *)studioTableView{
    if (!_studioTableView) {
        _studioTableView = [[MXBaseTableView alloc]initWithFrame:CGRectMake(0, swj_navigationBarHeight(), swj_screenWidth(), swj_screenHeight()-swj_navigationBarHeight()-swj_tabbarHeight()) style:UITableViewStylePlain];
        [MXStudioTableViewCell registerTableViewCellWithTableView:_studioTableView];
        _studioTableView.delegate = self;
        _studioTableView.dataSource = self;
        _studioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _studioTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        // 无数据占位图点击的回调
        WeakSelf(ws)
        _studioTableView.noContentViewTapedBlock = ^{
            [ws refreshHeader:YES];
        };
        if (@available(iOS 11.0,*)) {
            _studioTableView.estimatedRowHeight = 0;
            _studioTableView.estimatedSectionHeaderHeight = 0;
            _studioTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _studioTableView.estimatedRowHeight = 0;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader:)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 马上进入刷新状态
        _studioTableView.mj_header = header;
        // 自定义上拉刷新
        _studioTableView.mj_footer = [MXPCFooterRefresh footerWithRefreshingBlock:^{
            //下拉加载更多数据
            [ws uprefresh];
        }];


    }
    return _studioTableView;
}
//无网占位图
-(MXEmptyTipView *)emptyView{
    WeakSelf(ws)
    if (!_emptyView) {
        _emptyView = [[MXEmptyTipView alloc]initWithFrame:self.view.frame icon:nil title:nil];
        _emptyView.reloadAgain = ^{
            [ws createUI];
        };
    }
    return _emptyView;
}
//科室下拉选择视图
- (MXMeunView *)menuDataView
{
    if (!_menuDataView) {
        _menuDataView = [[MXMeunView alloc] init];
        _menuDataView.frame = CGRectMake(0, swj_navigationBarHeight(), swj_screenWidth(), swj_screenHeight()-swj_statusBarHeight()-swj_tabbarHeight());
        WeakSelf(weakSelf)
        _menuDataView.viewType = @"department";
        _menuDataView.departmentBlock = ^(MXStudioDepartmentModel *departmentModel) {
            MXLog(@"==%@==",departmentModel.departmentName);
            if (departmentModel != nil) {
                [weakSelf.navView.selectDepartmentBtn setTitle:[NSString stringWithFormat:@"%@ ",departmentModel.departmentName] forState:UIControlStateNormal];
                weakSelf.departmentModel = departmentModel;
                [weakSelf refreshHeader:YES];
        }
            [weakSelf.navView UpdateTheConstraints];
            weakSelf.navView.selectDepartmentBtn.imageView.transform = CGAffineTransformIdentity;
            _isShowDepartment = NO;
            weakSelf.departmentModel = departmentModel;
            [weakSelf.studioTableView.mj_header beginRefreshing];
        };
    }
    return _menuDataView;
}
-(NSMutableDictionary *)params{
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}
- (NSMutableArray *)departmentListArr{
    if (!_departmentListArr) {
        _departmentListArr = [[NSMutableArray alloc]init];
    }
    return _departmentListArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
