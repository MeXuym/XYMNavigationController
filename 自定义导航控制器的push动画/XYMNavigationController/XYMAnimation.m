//
//  XYMAnimation.m
//  自定义导航控制器的push动画
//
//  Created by jack xu on 16/12/9.
//  Copyright © 2016年 jack xu. All rights reserved.
//

#import "XYMAnimation.h"

@interface XYMAnimation ()

@property(nonatomic,strong)NSMutableArray * screenShotArray;

/**
 所属的导航栏有没有TabBarController
 */
@property (nonatomic,assign)BOOL isTabbarExist;

@end

@implementation XYMAnimation

+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation NavigationController:(UINavigationController *)navigationController
{
    XYMAnimation * ac = [[XYMAnimation alloc]init];
    ac.navigationController = navigationController;
    ac.navigationOperation = operation;
    return ac;
}
+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation
{
    XYMAnimation * ac = [[XYMAnimation alloc]init];
    ac.navigationOperation = operation;
    return ac;
}

- (void)setNavigationController:(UINavigationController *)navigationController
{
    _navigationController = navigationController;
    
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    //判断该导航栏是否有TabBarController
    if (self.navigationController.tabBarController == beyondVC) {
        _isTabbarExist = YES;
    }
    else
    {
        _isTabbarExist = NO;
    }
}

- (NSMutableArray *)screenShotArray
{
    if (_screenShotArray == nil) {
        _screenShotArray = [[NSMutableArray alloc]init];
    }
    return _screenShotArray;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .4f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIImageView * screentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImage * screenImg = [self screenShot];
    screentImgView.image =screenImg;
    
    //提供一个key，返回对应的VC,ToView对应切入的VC。
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //containerView是VC切换时候的view容器，将要切入的view加入到该view容器中。
    UIView * containerView = [transitionContext containerView];
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        
        
        [self.screenShotArray addObject:screenImg];
        //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
        [containerView addSubview:toView];
        //将截图添加到导航栏的View所属的window上
        [self.navigationController.view.window insertSubview:screentImgView atIndex:0];
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screentImgView.center = CGPointMake(-ScreenWidth/2, ScreenHeight / 2);
            
        } completion:^(BOOL finished) {
            
            [screentImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
    if (self.navigationOperation == UINavigationControllerOperationPop) {
        
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        lastVcImgView.image = [self.screenShotArray lastObject];
        screentImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screentImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screentImgView.layer.shadowOpacity = 0.6;
        [self.navigationController.view.window addSubview:lastVcImgView];
        [self.navigationController.view addSubview:screentImgView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screentImgView.center = CGPointMake(ScreenWidth * 3 / 2 , ScreenHeight / 2);
            lastVcImgView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            
        } completion:^(BOOL finished) {
            
            [lastVcImgView removeFromSuperview];
            [screentImgView removeFromSuperview];
            [self.screenShotArray removeLastObject];
            [transitionContext completeTransition:YES];
            
        }];
    }
}

- (void)removeLastScreenShot
{
    [self.screenShotArray removeLastObject];
    
}
- (void)removeAllScreenShot
{
    [self.screenShotArray removeAllObjects];
}
- (void)removeLastScreenShotWithNumber:(NSInteger)number
{
    for (NSInteger  i = 0; i < number ; i++) {
        [self.screenShotArray removeLastObject];
    }
}

- (UIImage *)screenShot
{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    
    CGSize size = beyondVC.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return snapshot;
}


@end
