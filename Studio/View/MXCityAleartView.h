//
//  MXCityAleartView.h
//  MXNurseUser
//
//  Created by 🔥 天府 浩成 🔥 on 2019/5/27.
//  Copyright © 2019年 LEI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MXCityModel;
@interface MXCityAleartView : UIView
@property (nonatomic, copy)void (^MXSelectCityBlock)(MXCityModel *cityModel);
@end
