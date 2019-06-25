//
//  MXEvaluationViewController.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/27.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXEvaluationViewController.h"
#import "MXEvaluationSelectView.h"
#import "MXNurseCommend.h"
#import "MXEvaluationsTableViewCell.h"
#import "MXStudioService.h"
@interface MXEvaluationViewController ()<UITableViewDelegate, UITableViewDataSource,MXEvaluationSelectViewDelegate>
{
    int _page;
    NSString *_level;
}
@property (nonatomic, strong) MXEvaluationSelectView *evaluationView;
@property (nonatomic, strong) UIView *sliderSegmentBackgroundView;
/** 列表 */
@property (nonatomic, strong) MXBaseTableView *totlaTable;
/** 评论数组 */
@property (nonatomic, strong) NSMutableArray *totlaCommentArray;
/** 页数 */
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation MXEvaluationViewController
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
    self.view.backgroundColor = kGrayColor;
    [self.view addSubview:self.sliderSegmentBackgroundView];
    _page = 1;
    [self getNurseCommendCount];
    [self.view addSubview:self.totlaTable];
}
#pragma mark - < 网络请求 >
//获取评论列表数据
- (void)getNewNurseCommendData:(BOOL)isRefreshHeader
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_studioModel.Id forKey:@"workId"];
    [params setValue:@(_page) forKey:@"p"];
    [params setValue:@"1" forKey:@"type"];// 1.用户评论 2.护士评论
    [params setValue:_level forKey:@"level"];

    [MXStudioService req_getWorkEvaluationListWithParam:params isRefresh:isRefreshHeader Response:^(id response) {
        _evaluationView.userInteractionEnabled = YES;
        if (_page == 1) {
            [self.totlaCommentArray removeAllObjects];
        }
        //数据容错处理
        if (![MXTool pc_isNullOrNilWithObject:response]) {
            NSArray *evaluationListArr = [response objectForKey:@"list"];
            for (NSDictionary *goodsDic in evaluationListArr) {
                MXEvaluationModel *commend = [MXEvaluationModel mj_objectWithKeyValues:goodsDic];
                MXNurseCommend *model = [[MXNurseCommend alloc]init];
                model.userPhone = commend.E_name;
                model.time = commend.E_create_time;
                model.content  = commend.E_content;
                model.level = commend.E_level;
                model.goodsName = commend.E_goods_name;
                model.cellHeight = commend.cellHeight;
                model.tagValue = commend.E_tag_value;
                model.E_detail_address = commend.E_detail_address;
                model.url = commend.url;
                [self.totlaCommentArray addObject:model];
            }
            BOOL hasNextPage = [[response objectForKey:@"hasNextPage"] boolValue];
            
            if (hasNextPage) {
                [_totlaTable.mj_footer endRefreshing];
            }else {
                [_totlaTable.mj_footer endRefreshingWithNoMoreData];
            }
            [_totlaTable.mj_header endRefreshing];
        }else{
            [MBProgressHUD showHUDMsg:response];
        }
        
        if (_totlaCommentArray.count == 0||_totlaCommentArray==nil) {
            [self.totlaTable showEmptyViewWithType:0];
        }else{
            // 移除无数据占位图
            [self.totlaTable removeEmptyView];
        }
        [self.totlaTable reloadData];

    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
        if (_totlaCommentArray.count == 0||_totlaCommentArray==nil) {
            [self.totlaTable showEmptyViewWithType:0];
        }
        [_totlaTable.mj_header endRefreshing];
        [_totlaTable.mj_footer endRefreshingWithNoMoreData];
        _evaluationView.userInteractionEnabled = YES;

    } toView:self.view];
}
//获取评价数量
- (void)getNurseCommendCount{
//    [MBProgressHUD showLoadHUD];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_studioModel.Id forKey:@"workId"];
    [params setValue:@"1" forKey:@"type"];// 1.用户评论 2.护士评论
    
    [MXStudioService req_getWorkEvaluationCountWithParam:params Response:^(id response) {
        //数据容错处理
        if (![MXTool pc_isNullOrNilWithObject:response]) {
            [self setSegementDataSource:response];
        }
        [self getNewNurseCommendData:YES];

    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
        if (_totlaCommentArray.count == 0||_totlaCommentArray==nil) {
            [self.totlaTable showEmptyViewWithType:0];
        }
        [_totlaTable.mj_header endRefreshing];
        [_totlaTable.mj_footer endRefreshingWithNoMoreData];

    } toView:self.view];
}
#pragma mark -- 上拉加载、下拉刷新
-(void)refreshHeader:(BOOL)isShowProgressHUD{
    if (_evaluationView.evaluationArr.count == 0||_evaluationView.evaluationArr == nil) {
        //发送通知请求工作室头部信息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getWorkDetails" object:nil];
        [self getNurseCommendCount];
    }
    _page = 1;
    [self getNewNurseCommendData:isShowProgressHUD];
}
-(void)uprefresh{
    _evaluationView.userInteractionEnabled = NO;
    _page++;
    [self getNewNurseCommendData:NO];
}

-(void)setSegementDataSource:(NSDictionary *)jsonData{
    NSMutableArray *commentCount = [NSMutableArray array];
    if (![MXTool pc_isNullOrNilWithObject:jsonData]) {
        NSString *totalComment = [NSString stringWithFormat:@"%@\n全部",@([jsonData[@"total"]integerValue])];
        [commentCount addObject:totalComment];
        NSString *oneComment = [NSString stringWithFormat:@"%@\n非常满意",@([jsonData[@"level_5"]integerValue])];
        [commentCount addObject:oneComment];
        NSString *twoComment = [NSString stringWithFormat:@"%@\n满意",@([jsonData[@"level_4"]integerValue])];
        [commentCount addObject:twoComment];

        NSString *threeComment = [NSString stringWithFormat:@"%@\n一般",@([jsonData[@"level_3"]integerValue])];
        [commentCount addObject:threeComment];

        NSString *fourComment = [NSString stringWithFormat:@"%@\n差评",@([jsonData[@"level_2"]integerValue])];
        [commentCount addObject:fourComment];

        NSString *fiveComment = [NSString stringWithFormat:@"%@\n恶劣",@([jsonData[@"level_1"]integerValue])];
        [commentCount addObject:fiveComment];
    }else{
        [commentCount addObject:@"0\n全部"];
        [commentCount addObject:@"0\n非常满意"];
        [commentCount addObject:@"0\n满意"];
        [commentCount addObject:@"0\n一般"];
        [commentCount addObject:@"0\n差评"];
        [commentCount addObject:@"0\n恶劣"];
    }
    _evaluationView.evaluationArr = commentCount;
}
#pragma mark --tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totlaCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXEvaluationsTableViewCell *cell = [MXEvaluationsTableViewCell cellWithTableView:tableView];
    cell.commend = self.totlaCommentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXEvaluationModel *commend = self.totlaCommentArray[indexPath.row];
    MXLog(@"第%ld行它的行高是%f",(long)indexPath.row,commend.cellHeight);
    return commend.cellHeight;
}
-(void)selectFiltrate:(NSString *)selectLevelStr{
    _level = selectLevelStr;
    [self refreshHeader:YES];
}
#pragma mark - < 懒加载 >
-(MXEvaluationSelectView *)evaluationView{
    if (!_evaluationView) {
        _evaluationView = [[MXEvaluationSelectView alloc]initWithFrame:CGRectMake(0, YMWidth(12), swj_screenWidth(), YMWidth(39))];
        _evaluationView.evaluationDelegate = self;
    }
    return _evaluationView;
}
-(UIView *)sliderSegmentBackgroundView{
    if (!_sliderSegmentBackgroundView) {
        _sliderSegmentBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,YMWidth(10), swj_screenWidth(), YMWidth(51))];
        _sliderSegmentBackgroundView.backgroundColor = WHITE;
        [MXTool base_viewlayerAddCornerRadi:_sliderSegmentBackgroundView oneCorner:UIRectCornerTopLeft twoCorner:UIRectCornerTopRight radii:YMWidth(20)];
        [_sliderSegmentBackgroundView addSubview:self.evaluationView];
        UIView * lineView = [[UIView alloc]init];
        lineView.backgroundColor = kGrayColor;
        [_sliderSegmentBackgroundView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_sliderSegmentBackgroundView);
            make.bottom.mas_equalTo(_sliderSegmentBackgroundView.mas_bottom).offset(-1);
            make.height.mas_equalTo(YMWidth(1));
        }];
    }
    return _sliderSegmentBackgroundView;
}
- (UITableView *)totlaTable
{
    if (!_totlaTable) {
        _totlaTable = [[MXBaseTableView alloc]initWithFrame:CGRectMake(0,YMWidth(60), swj_screenWidth(), swj_screenHeight()-swj_navigationBarHeight()-YMWidth(206)) style:UITableViewStylePlain];
        _totlaTable.delegate = self;
        _totlaTable.dataSource = self;
        _totlaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _totlaTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        // 无数据占位图点击的回调
        WeakSelf(ws)
        _totlaTable.noContentViewTapedBlock = ^{
            [ws refreshHeader:YES];
        };
        if (@available(iOS 11.0,*)) {
            _totlaTable.estimatedRowHeight = 0;
            _totlaTable.estimatedSectionHeaderHeight = 0;
            _totlaTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _totlaTable.estimatedRowHeight = YMWidth(50);
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader:)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 马上进入刷新状态
        _totlaTable.mj_header = header;
        _totlaTable.mj_footer = [MXPCFooterRefresh footerWithRefreshingBlock:^{
            //下拉加载更多数据
            [ws uprefresh];
        }];
        
    }
    return _totlaTable;
}
- (NSMutableArray *)totlaCommentArray
{
    if (!_totlaCommentArray) {
        _totlaCommentArray = [NSMutableArray array];
    }
    return _totlaCommentArray;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
