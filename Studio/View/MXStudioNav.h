//
//  MXStudioNav.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MXStudioNavDelegate <NSObject>
//城市选择
-(void)selectCity;
//科室选择
-(void)selectDepartment;
@end
@interface MXStudioNav : UIView
@property (nonatomic, strong) UIButton *selectCityBtn;
@property (nonatomic, strong) UIButton *selectDepartmentBtn;
@property(nonatomic, weak)id <MXStudioNavDelegate> delegate;
//选择完成后更新约束
-(void)UpdateTheConstraints;
@end
