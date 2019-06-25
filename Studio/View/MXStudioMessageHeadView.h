//
//  MXStudioMessageHeadView.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/24.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXStudioModel.h"
@protocol MXStudioMessageHeadViewDelegate <NSObject>
@optional
//关注、取消关注  follow1：关注；2：取消关注
-(void)selectfocusOn:(NSString *)follow withButton:(UIButton*)btn;
//点击跳入工作室详情
-(void)didSelectAboutStudio;
@end
@interface MXStudioMessageHeadView : UIView
@property (nonatomic, strong) UIImageView *studioImageV;
@property (nonatomic, strong) UILabel *studioTitle;
@property (nonatomic, strong) UIButton *focusOnBtn;
@property (nonatomic, strong) UILabel *businessHours;
@property (nonatomic, strong) UILabel *nurseCountLabel;
@property (nonatomic, strong) UILabel *fansCountLabel;
@property (nonatomic, strong) UIButton *nurseCountBtn;
@property (nonatomic, strong) UIButton *fansCountBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) MXStudioModel *studioMode;
@property (nonatomic, strong) MXStudioDetailsModel *studioDetailsMode;
@property(nonatomic, weak)id <MXStudioMessageHeadViewDelegate> delegate;
@end
