//
//  RootViewController.m
//  自定义导航控制器的push动画
//
//  Created by jack xu on 16/12/7.
//  Copyright © 2016年 jack xu. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "RootViewController.h"
#import "TwoViewController.h"
#import "XYMPushAnmation.h"

@interface RootViewController ()<UINavigationControllerDelegate>

@property(strong,nonatomic)UIImageView * screenshotImgView;
@property(strong,nonatomic)UIView * coverView;
@property(strong,nonatomic)NSMutableArray * screenshotImgs;


@property(nonatomic,strong)UIImage * nextVCScreenShotImg;

@property (nonatomic,strong)XYMPushAnmation *xymPushAnmation;

@end

@implementation RootViewController

- (XYMPushAnmation *)xymPushAnmation
{
    if (_xymPushAnmation == nil) {
        _xymPushAnmation = [[XYMPushAnmation alloc]init];
        
    }
    return _xymPushAnmation;
}

- (void)viewDidLoad {

    self.delegate = self;
    _xymPushAnmation = [[XYMPushAnmation alloc] init];
}

//这个代理方法里面使用我们的自定义的动画
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    self.xymPushAnmation.navigationOperation = operation;
    self.xymPushAnmation.navigationController = self;
    return self.xymPushAnmation;
}


//push之前会先截图
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    // 只有在导航控制器里面有子控制器的时候才需要截图
    if (self.viewControllers.count >= 1) {
        // 调用自定义方法,使用上下文截图
        [self screenShot];
    }
    
    [super pushViewController:viewController animated:animated];
    
    
}

//pop的时候
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //index == 1 的时候是根视图
    NSInteger index = self.viewControllers.count;
    NSString * className = nil;
    if (index >= 2) {
        className = NSStringFromClass([self.viewControllers[index -2] class]);
    }
    
    
    if (_screenshotImgs.count >= index - 1) {
        [_screenshotImgs removeLastObject];
    }
    
    
    return [super popViewControllerAnimated:animated];
}

// 使用上下文截图,并使用指定的区域裁剪,模板代码
- (void)screenShot
{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    UIViewController *beyondVC = self.view.window.rootViewController;
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
    // 添加截取好的图片到图片数组
    if (snapshot) {
        [_screenshotImgs addObject:snapshot];
        //self.lastVCScreenShotImg = snapshot;
    }
    
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
