//
//  MXAboutStudiosViewController.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/29.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXAboutStudiosViewController.h"
#import "MXStudioMessageHeadView.h"
#import "MXAboutStudioTableViewCell.h"
#import "MXAboutStudioModel.h"
#import "MXShareSheetView.h"
#import "MXStudioService.h"
@interface MXAboutStudiosViewController ()<MXStudioMessageHeadViewDelegate,UITableViewDelegate, UITableViewDataSource,MXAboutStudioTableViewCellDelegate>
@property (nonatomic, strong) MXStudioMessageHeadView *headView;
@property (nonatomic, strong) UITableView *aboutStudioTableView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UITextView *introTextView;
@property (nonatomic, strong) MXAboutStudioModel *myModel;
@property (nonatomic, assign) BOOL isSelect;//是否点击了关注按钮
@end

@implementation MXAboutStudiosViewController
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
    self.title = @"金牌康护";
    [self setNav];
    [self createUI];
}
-(void)createUI{
    self.view.backgroundColor = kGrayColor;
    [self.view addSubview:self.aboutStudioTableView];
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
//请求工作室头部信息
-(void)getWorkDetails{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_studioModel.Id forKey:@"workId"];
    [params setValue:@"2" forKey:@"type"];
    [params setValue:MXUserId forKey:USER_ID];
    
    [MXStudioService req_workDetailsWithParam:params isRefresh:YES Response:^(id response) {
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
-(void)goToShare{
    if (self.studioModel) {
        NSString * urlStr = [NSString stringWithFormat:@"%@studio/HospitalStudio/detail.html?id=%@&type=%@",BASE_WAP_URL,_studioModel.Id,_studioModel.type];
        MXShareSheetView *shareView = [[MXShareSheetView alloc] initWithTitle:_studioModel.name andSubTitle:_studioModel.introduce andUrlStr:urlStr andImg:_headView.studioImageV.image andTypeNo:1 andGoodsID:nil];
        [self presentViewController:shareView animated:YES completion:^{
            
        }];
    }
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
            [self getWorkDetails];
        }else{
            MXLog(@"操作失败");
        }
    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
    } toView:self.view];
    _isSelect = YES;
}
#pragma mark --tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXAboutStudioTableViewCell *cell = [MXAboutStudioTableViewCell dequeueReusableCellWithTableView:tableView indexPath:indexPath];
    cell.delegate = self;
    _myModel = [[MXAboutStudioModel alloc]init];
    _myModel.address = _studioModel.detailAddress;
    _myModel.intro = _studioModel.introduce;
    [cell configInfo:_myModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _myModel.cellHeight;
}
-(void)selectCallPhone{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_studioModel.telephone];[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark - < 懒加载 >
-(MXStudioMessageHeadView *)headView{
    if (_headView == nil) {
        _headView = [[MXStudioMessageHeadView alloc]initWithFrame:CGRectMake(0, 0, swj_screenWidth(), YMWidth(115))];
        _headView.delegate =self;
        _headView.backgroundColor = WHITE;
    }
    return _headView;
}
- (UITableView *)aboutStudioTableView
{
    if (!_aboutStudioTableView) {
        _aboutStudioTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,swj_navigationBarHeight(), swj_screenWidth(), swj_screenHeight()-swj_navigationBarHeight()) style:UITableViewStylePlain];
        [MXAboutStudioTableViewCell registerTableViewCellWithTableView:_aboutStudioTableView];
        _aboutStudioTableView.delegate = self;
        _aboutStudioTableView.dataSource = self;
        _aboutStudioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _aboutStudioTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _aboutStudioTableView.backgroundColor = kGrayColor;
        _headView = [[MXStudioMessageHeadView alloc]initWithFrame:CGRectMake(0, 0, swj_screenWidth(), YMWidth(115))];
        _headView.studioMode = _studioModel;
        _headView.studioDetailsMode = _detailsModel;
        _headView.delegate = self;
        _headView.backgroundColor = WHITE;
        
        _aboutStudioTableView.tableHeaderView = _headView;
        if (@available(iOS 11.0,*)) {
            _aboutStudioTableView.estimatedRowHeight = 0;
            _aboutStudioTableView.estimatedSectionHeaderHeight = 0;
            _aboutStudioTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _aboutStudioTableView.estimatedRowHeight = 0;
        
    }
    return _aboutStudioTableView;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.callBackBlock(_isSelect);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
