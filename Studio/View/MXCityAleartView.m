//
//  MXCityAleartView.m
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/27.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXCityAleartView.h"
#import "MXCityManager.h"
#import "MXLocationManager.h"
#import "MXCityModel.h"
#import "MXHotCityCell.h"
#import "NSString+PinYin.h"
#import "MXStudioService.h"
@interface MXCityAleartView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *hotCityArray;
@property (nonatomic, strong) MXLocationManager *loactionManager;
@property (nonatomic, copy) NSString *locationCityName;
/**
 索引数组
 */
@property (nonatomic, strong) NSMutableArray *indexArray;

/**
 索引title数组
 */
@property (nonatomic, strong) NSMutableArray *indexTitleArray;
@end
@implementation MXCityAleartView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
//    __weak typeof(self)  weakSelf = self;
    NSString *locatCity = [[NSUserDefaults standardUserDefaults]objectForKey:MXLocatCityKey];
    if (locatCity.length) {
        
        self.locationCityName = locatCity;
    }
    
    [self addSubview:self.cityTableView];
    [self getCityData];
}
- (void)getCityData
{
    [MXStudioService req_studioCityListWithParam:nil Response:^(id response) {
        NSDictionary * dataDic = [[response objectForKey:@"result"] objectForKey:@"list"];
        //添加索引标题
        NSArray *letterArray = [[dataDic allKeys]sortedArrayUsingSelector:@selector(compare:)];
        self.indexTitleArray = [NSMutableArray arrayWithArray:letterArray];
        
        for (NSString *key in self.indexTitleArray) {
            
            NSArray *letterArray = [MXCityModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:key]];
            if (letterArray == nil) {
                letterArray = [NSArray array];
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:letterArray forKey:key];
            [self.indexArray addObject:dict];
        }
        [self.cityTableView reloadData];
    } ErrorMessage:^(NSString *msg) {
        [MBProgressHUD showHUDMsg:msg];
    } toView:self];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDict = self.indexArray[section];
    NSString *key = self.indexTitleArray[section];
    NSArray *array = sectionDict[key];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDict = self.indexArray[section];
    NSString *key = self.indexTitleArray[section];
    NSArray *array = sectionDict[key];
    if (array.count != 0) {
        return 45;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        NSDictionary *sectionDict = self.indexArray[indexPath.section];
        NSString *key = self.indexTitleArray[indexPath.section];
        NSArray *array = sectionDict[key];
        MXCityModel *cityModel = array[indexPath.row];
        
        if (self.MXSelectCityBlock) {
            self.MXSelectCityBlock(cityModel);
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        MXBaseCell *cell = (MXBaseCell *)[tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = kTableTitleColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.x = 15;
        NSDictionary *sectionDict = self.indexArray[indexPath.section];
        NSString *key = self.indexTitleArray[indexPath.section];
        NSArray *array = sectionDict[key];
        MXCityModel *cityModel = array[indexPath.row];
        cell.textLabel.text = cityModel.name;
        return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *selectionHeaderView = [[UIView alloc] init];
    NSDictionary *sectionDict = self.indexArray[section];
    NSString *key = self.indexTitleArray[section];
    NSArray *array = sectionDict[key];
    if (array.count != 0) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10, 0, 200, 45);
        titleLabel.font = kFontSize(14);
        titleLabel.textColor = kTableTitleColor;
        [selectionHeaderView addSubview:titleLabel];
        titleLabel.text = self.indexTitleArray[section];
        selectionHeaderView.backgroundColor = kGrayColor;
    }
    return selectionHeaderView;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexTitleArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index  {
    
    return index;
}
- (UITableView *)cityTableView
{
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] init];
        _cityTableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - swj_navigationBarHeight()-swj_statusBarHeight());
        [_cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityCell"];
        [_cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"hotCityCell"];
        _cityTableView.dataSource = self;
        _cityTableView.delegate = self;
    }
    return _cityTableView;
}

- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (NSMutableArray *)hotCityArray {
    if (!_hotCityArray) {
        _hotCityArray = [NSMutableArray array];
    }
    return _hotCityArray;
}

- (NSMutableArray *)indexArray {
    
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)indexTitleArray {
    if (!_indexTitleArray) {
        _indexTitleArray = [NSMutableArray array];
    }
    return _indexTitleArray;
}
@end
