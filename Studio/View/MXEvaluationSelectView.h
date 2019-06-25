//
//  MXEvaluationSelectView.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/6/11.
//  Copyright © 2019年 MeiXin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MXEvaluationSelectViewDelegate <NSObject>
//点击了筛选
-(void)selectFiltrate:(NSString*)selectLevelStr;
@end
@interface MXEvaluationSelectView : UIScrollView
@property (nonatomic, strong) NSMutableArray *evaluationArr;
@property(nonatomic, weak)id <MXEvaluationSelectViewDelegate> evaluationDelegate;
@end
