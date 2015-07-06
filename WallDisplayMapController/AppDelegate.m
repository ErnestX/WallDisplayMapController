//
//  AppDelegate.m
//  WallDisplayMapController
//
//  Created by Jialiang Xiang on 2015-05-21.
//  Copyright (c) 2015 Jialiang. All rights reserved.
//

#import "AppDelegate.h"
#import "RabbitMQManager.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MapControlViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "UIColor+Extend.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Metrics viewController
    MasterViewController *masterVC = [[MasterViewController alloc] init];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    UINavigationController *masterNav = [[UINavigationController alloc]
                                         initWithRootViewController:masterVC];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    splitVC.title = @"Metrics";
    splitVC.tabBarItem.image = [[UIImage imageNamed:@"pieChatIcon_unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    splitVC.tabBarItem.selectedImage = [UIImage imageNamed:@"pieChatIcon.png"];
    splitVC.viewControllers = @[masterNav, detailNav];
    splitVC.maximumPrimaryColumnWidth = splitVC.view.bounds.size.width;
    splitVC.preferredPrimaryColumnWidthFraction = MASTER_VC_WIDTH_FRACTION;
    splitVC.view.backgroundColor = [UIColor colorWithFlatVersionOf:[UIColor darkGrayColor]];
    
    
    // Remote 3D viewController
    MapControlViewController *remoteVC = [[MapControlViewController alloc] init];
    remoteVC.title = @"Remote";
    remoteVC.tabBarItem.image = [[UIImage imageNamed:@"remoteIcon_unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    remoteVC.tabBarItem.selectedImage = [UIImage imageNamed:@"remoteIcon.png"];
    
    // Set up TabBar viewController
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = @[splitVC, remoteVC];
    tabVC.tabBar.tintColor = [UIColor whiteColor];
    tabVC.tabBar.barTintColor = [UIColor colorFromHexString:@"#1ABC9C"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorFromHexString:@"#CBCBCB"] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [[RabbitMQManager sharedInstance] closeRMQConnection];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
//        [[RabbitMQManager sharedInstance] openRMQConnection];
        
    });
    

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
