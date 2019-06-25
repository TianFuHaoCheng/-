//
//  MXStudioTableViewCell.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXPCBaseTableViewCell.h"
#import "MXStudioModel.h"
@interface MXStudioTableViewCell : MXPCBaseTableViewCell
@property (nonatomic, strong) MXStudioModel *model;
@property (nonatomic, strong) UIImageView *studioImageV;
@property (nonatomic, strong) UILabel *studioTitle;
@property (nonatomic, strong) UILabel *studioMessage;
@property (nonatomic, strong) UIImageView *kindBackgroundImageV;//属于哪个科室背景图
@property (nonatomic, strong) UILabel *studioKind;//科室种类如：儿科等...
@property (nonatomic, strong) UIView *lineView;
@end
