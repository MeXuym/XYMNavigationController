//
//  XYMNavigationController.h
//  自定义导航控制器的push动画
//
//  Created by jack xu on 16/12/9.
//  Copyright © 2016年 jack xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYMNavigationController : UINavigationController

@property(strong,nonatomic)UIScreenEdgePanGestureRecognizer *panGestureRec;

@end
