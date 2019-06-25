//
//  MXAboutStudiosViewController.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/29.
//  Copyright © 2019年 LEI. All rights reserved.
//  工作室详情页

#import "MXBaseNewViewController.h"
#import "MXStudioModel.h"
typedef void(^MXAboutStudioVCBlock) (BOOL isSelect);//isSelect 是否点击了关注按钮
@interface MXAboutStudiosViewController : MXBaseNewViewController
@property (nonatomic, strong) MXStudioModel *studioModel;
@property (nonatomic, strong) MXStudioDetailsModel *detailsModel;
@property (nonatomic,copy)MXAboutStudioVCBlock callBackBlock;
@end
