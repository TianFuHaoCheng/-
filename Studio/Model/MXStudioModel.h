//
//  MXStudioModel.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/6/10.
//  Copyright © 2019年 MeiXin. All rights reserved.
//

#import <Foundation/Foundation.h>
//工作室列表模型
@interface MXStudioModel : NSObject
@property (nonatomic, copy) NSString *nurseName;//护士名称
@property (nonatomic,assign) NSInteger orderType;
@property (nonatomic,assign) NSInteger followCount;
@property (nonatomic, copy) NSString *city;//城市名称
@property (nonatomic, copy) NSString *sfz;//
@property (nonatomic, copy) NSString *departmentId;//科室id
@property (nonatomic, copy) NSString *creatorId;//
@property (nonatomic, copy) NSString *creatorName;//
@property (nonatomic, copy) NSString *lon;//经度
@property (nonatomic, copy) NSString *type;//工作室类型 1.个人 2.医院
@property (nonatomic, copy) NSString *province;//所属省份
@property (nonatomic, copy) NSString *paySign;//
@property (nonatomic, copy) NSString *workImg;//工作室log图片地址
@property (nonatomic, copy) NSString *serverTime;//服务时间
@property (nonatomic, copy) NSString *startTime;//
@property (nonatomic, copy) NSString *Id;//工作室id
@property (nonatomic, copy) NSString *hospital;//
@property (nonatomic, copy) NSString *keyword;//
@property (nonatomic, copy) NSString *lat;//纬度
@property (nonatomic, copy) NSString *area;//地区
@property (nonatomic, copy) NSString *brief;//
@property (nonatomic, copy) NSString *departmentName;//科室名称
@property (nonatomic, copy) NSString *jobtitle;//职业名称
@property (nonatomic, copy) NSString *introduce;//工作室简介
@property (nonatomic, copy) NSString *nursePhone;//护士电话号码
@property (nonatomic, copy) NSString *orderby;//
@property (nonatomic, copy) NSString *telephone;//
@property (nonatomic, copy) NSString *jobtitleId;//职业id
@property (nonatomic, copy) NSString *userName;//
@property (nonatomic,assign) NSInteger nurseCount;//护士个数
@property (nonatomic, copy) NSString *name;//工作室名称
@property (nonatomic, copy) NSString *detailAddress;//工作室地址
@property (nonatomic, copy) NSString *ids;//
@property (nonatomic, copy) NSString *endTime;//
@property (nonatomic,assign) NSInteger status;//
@end
//科室列表
@interface MXStudioDepartmentModel : NSObject
@property (nonatomic, copy) NSString *departmentName;//科室名称
@property (nonatomic, copy) NSString *departmentId;//科室Id
@property (nonatomic,assign) NSInteger sort;
@end
//工作室详情顶部
@interface MXStudioDetailsModel : NSObject
@property (nonatomic, copy) NSString *department;//科室名称
@property (nonatomic,assign) NSInteger workSum;
@property (nonatomic,assign) NSInteger fans;
@property (nonatomic, copy) NSString *jurisdiction;//管理权力等级
@property (nonatomic, copy) NSString *wxCodeUrl;//微信二维码
@property (nonatomic, assign) BOOL isFollow;//是否已关注
@end
//工作室详情页 品类导航栏列表
@interface MXProductModel : NSObject
@property (nonatomic, copy) NSString *productTitle;//导航分类标题
@property (nonatomic, copy) NSString *productId;//导航分类id
@end
//工作室详情页 品类列表
@interface MXWorkGoodsModel : NSObject
@property (nonatomic, copy) NSString *subTitle;//副标题
@property (nonatomic, copy) NSString *goodsId;//服务Id
@property (nonatomic, copy) NSString *title;//标题(服务名称)
@property (nonatomic, copy) NSString *workId;//工作室Id
@property (nonatomic, copy) NSString *url;//服务图片
@end
//工作室详情页 评论列表
@interface MXEvaluationModel : NSObject
@property (nonatomic, copy) NSString *E_goods_id;//服务Id
@property (nonatomic, copy) NSString *E_nurse_id;//被评论人Id
@property (nonatomic, copy) NSString *E_tag_id;//评价标签Id(多个逗号隔开)
//@property (nonatomic, copy) NSString *E_level;//评论星级
@property (nonatomic,assign) NSInteger E_level;
@property (nonatomic, copy) NSString *E_status;//
@property (nonatomic, copy) NSString *E_order_id;//订单id
@property (nonatomic, copy) NSString *E_content;//评论内容
@property (nonatomic, copy) NSString *E_create_time;//评论时间
@property (nonatomic, copy) NSString *E_is_anonymous;//是否匿名评论 0.不匿名 1.匿名
@property (nonatomic, copy) NSString *E_id;//评论id
@property (nonatomic, copy) NSString *E_tag_value;//评论标签名称
@property (nonatomic, copy) NSString *E_goods_name;//服务名称
@property (nonatomic, copy) NSString *E_detail_address;//服务地址
@property (nonatomic, copy) NSString *E_creator_id;//评论人id
@property (nonatomic, copy) NSString *E_name;//评论人名称
@property (nonatomic, copy) NSString *url;//评论人头像
@property (nonatomic, copy) NSString *E_phone;//评论人手机号
@property (nonatomic, copy) NSString *E_sex;//评论性别
@property (nonatomic, assign) CGFloat cellHeight;//cell高度
@property (nonatomic, assign) BOOL showStarView;
@end

