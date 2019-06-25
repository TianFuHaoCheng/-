//
//  MXAboutStudioTableViewCell.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/28.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import "MXPCBaseTableViewCell.h"
#import "MXAboutStudioModel.h"
@protocol MXAboutStudioTableViewCellDelegate <NSObject>
//点击了筛选
-(void)selectCallPhone;
@end
@interface MXAboutStudioTableViewCell : MXPCBaseTableViewCell
@property (nonatomic, strong) MXAboutStudioModel *model;
@property(nonatomic, weak)id <MXAboutStudioTableViewCellDelegate> delegate;

@end
