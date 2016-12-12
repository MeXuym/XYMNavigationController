//
//  AnimationContoller.m
//  ChongZu
//
//  Created by 孔令涛 on 2016/10/9.
//  Copyright © 2016年 cz10000. All rights reserved.
//

#import "AnimationContoller.h"
@interface AnimationContoller ()

@property(nonatomic,strong)NSMutableArray * screenShotArray;

@end

@implementation AnimationContoller

+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation NavigationController:(UINavigationController *)navigationController
{
    AnimationContoller * ac = [[AnimationContoller alloc]init];
    ac.navigationController = navigationController;
    ac.navigationOperation = operation;
    return ac;
}
+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation
{
    AnimationContoller * ac = [[AnimationContoller alloc]init];
    ac.navigationOperation = operation;
    return ac;
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
    return .3f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    

    UIImageView * screentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImage * screenImg = [self screenShot];
    screentImgView.image =screenImg;
    
    //取出fromViewController,fromView和toViewController，toView
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //提供一个key，返回对应的VC。现在的SDK中key的选择只有UITransitionContextFromViewControllerKey和UITransitionContextToViewControllerKey两种，分别表示将要切出和切入的VC。
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    //得到切换结束时某个VC应在的frame。
    CGRect fromViewEndFrame = [transitionContext finalFrameForViewController:fromViewController];
    fromViewEndFrame.origin.x = ScreenWidth;
    CGRect fromViewStartFrame = fromViewEndFrame;
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toViewStartFrame = toViewEndFrame;
    
    //VC切换所发生的view容器，开发者应该将切出的view移除，将切入的view加入到该view容器中。
    UIView * containerView = [transitionContext containerView];
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {

        
        [self.screenShotArray addObject:screenImg];
        //toViewStartFrame.origin.x += ScreenWidth;
        [containerView addSubview:toView];
        
        toView.frame = toViewStartFrame;
    
//        UIView * nextVC = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
         //[nextVC addSubview:[toView snapshotViewAfterScreenUpdates:YES]];

        [self.navigationController.tabBarController.view insertSubview:screentImgView atIndex:0];
        
        //[self.navigationController.tabBarController.view addSubview:nextVC];
//        nextVC.layer.shadowColor = [UIColor blackColor].CGColor;
//        nextVC.layer.shadowOffset = CGSizeMake(-0.8, 0);
//        nextVC.layer.shadowOpacity = 0.6;
 
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //toView.frame = toViewEndFrame;
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screentImgView.center = CGPointMake(-ScreenWidth/2, ScreenHeight / 2);
            //nextVC.center = CGPointMake(ScreenWidth/2, ScreenHeight / 2);
            
            
        } completion:^(BOOL finished) {

//            [nextVC removeFromSuperview];
            [screentImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
         
    }
    if (self.navigationOperation == UINavigationControllerOperationPop) {

        
//        fromViewStartFrame.origin.x = -ScreenWidth;
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        lastVcImgView.image = [self.screenShotArray lastObject];
        screentImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screentImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screentImgView.layer.shadowOpacity = 0.6;
        [self.navigationController.tabBarController.view addSubview:lastVcImgView];
        [self.navigationController.tabBarController.view addSubview:screentImgView];
        
       // fromView.frame = fromViewStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screentImgView.center = CGPointMake(ScreenWidth * 3 / 2 , ScreenHeight / 2);
            lastVcImgView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            //fromView.frame = fromViewEndFrame;
            
        } completion:^(BOOL finished) {
            //[self.navigationController setNavigationBarHidden:NO];
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
- (UIImage *)screenShot
{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = beyondVC.view.frame.size;
    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
    
 
    // 返回截取好的图片
    return snapshot;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
