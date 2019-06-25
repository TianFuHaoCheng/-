//
//  MXStudioService.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/6/21.
//  Copyright © 2019年 MeiXin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXStudioService : NSObject
/**
 城市列表 城市列表接口 jpwork/getWorkCityList.json（无需参数）
 */
+(void)req_studioCityListWithParam:(NSDictionary *)param Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;

/**
 科室列表 科室列表接口 jpwork/getWorkDepartmentList.json
 参数名    参数类型    必传    缺省值    描述
 前分页页数:p          否
 每页显示多少行:n       否
 */
+(void)req_workDepartmentListWithParam:(NSDictionary *)param Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;

/**
 工作室列表 工作室列表接口 jpwork/getWorkList.json
 参数名    参数类型       必传    缺省值    描述
 城市名称:city           否
 科室id:departmentId    否
 当前登录的用户Id:userId  否
 前分页页数:p            否
 每页显示多少行:n         否
 */
+(void)req_workListWithParam:(NSDictionary *)param isRefresh:(BOOL)isRefreshHeader Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;

/**
 查询工作室详情 查询工作室详情接口 jpwork/getWorkDetails.json
 参数名    参数类型    必传    缺省值    描述
 工作室id:workId      是    工作室id
 登录端口:type         是   登录端口 0：护士端，1：客户端
 当前登录的用户Id:userId 否  当前登录的用户Id
 前分页页数:p            否
 每页显示多少行:n         否
 */
+(void)req_workDetailsWithParam:(NSDictionary *)param isRefresh:(BOOL)isRefreshHeader Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;

/**
 通过品类获取医院工作室主页服务列表 通过品类获取医院工作室主页服务列表接口 jpwork/category/getWorkCategoryGoodsList.json
 参数名    参数类型    必传    缺省值    描述
 工作室id:workId      是    工作室id
 编辑:edit     是  医院工作室时，必填，0：首页(不可编辑的)，1：全部项目(可编辑的)
 品类Id:categoryId   否  品类Id
 渠道:deviceType   是    渠道-端1-pc;2-移动
 当前登录的用户Id:userId 是  当前登录的用户Id
 前分页页数:p            否
 每页显示多少行:n         否
 */
+(void)req_workCategoryGoodsListWithParam:(NSDictionary *)param isRefresh:(BOOL)isRefreshHeader Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;

/**
 查询评价数量 查询评价数量接口 jpwork/category/getWorkEvaluationCount.json
 参数名    参数类型    必传    缺省值    描述
 工作室id:workId      是    工作室id
 被评论人Id:nurseId   否    被评论人Id
 评论类型:type        否    评论类型 1.用户评论 2.护士评论
 */
+(void)req_getWorkEvaluationCountWithParam:(NSDictionary *)param Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;

/**
 查询工作室评价记录 查询工作室评价记录接口 jpwork/category/getWorkEvaluationList.json
 参数名    参数类型    必传    缺省值    描述
 工作室id:workId      是    工作室id
 被评论人Id:nurseId   否    被评论人Id
 评论类型:type        否    评论类型 1.用户评论 2.护士评论
 评论星级:level       否    评论星级
 p    否
 */
+(void)req_getWorkEvaluationListWithParam:(NSDictionary *)param isRefresh:(BOOL)isRefreshHeader Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;

/**
 修改用户关注状态 修改用户关注状态接口 jpwork/updateFollowState.json
 参数名    参数类型    必传    缺省值    描述
 工作室id:workId      是    工作室id
 登录端口:type         是   登录端口 0：护士端，1：客户端
 当前登录的用户Id:userId 是  当前登录的用户Id
 事件  是  1：关注；2：取消关注
 */
+(void)req_updateFollowStateWithParam:(NSDictionary *)param Response:(void (^)(id response))responseBlock ErrorMessage:(void (^)(NSString *msg))errorBlock toView:(UIView *)view;
@end
