//
//  MXEvaluationsTableViewCell.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/6/13.
//  Copyright © 2019年 MeiXin. All rights reserved.
//

#import "MXBaseTableViewCell.h"
#import "MXNurseCommend.h"
@interface MXEvaluationsTableViewCell : MXBaseTableViewCell
@property (nonatomic, strong) MXNurseCommend *commend;
+ (instancetype) cellWithTableView:(UITableView *)tableView;
@end
