//
//  MXHomePageViewController.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/27.
//  Copyright © 2019年 LEI. All rights reserved.
//  首页、全部项目

#import "MXBaseViewController.h"
#import "MXStudioModel.h"
@interface MXHomePageViewController : MXBaseViewController
@property (nonatomic, assign) NSInteger vcType;//0首页(不可编辑的)，1全部项目(可编辑的)
@property (nonatomic, strong) MXStudioModel *studioModel;
@end
