//
//  AppDelegate.m
//  Internationalization
//
//  Created by lyl on 2017/2/22.
//  Copyright © 2017年 lyl. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NSBundle+Language.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    //获取系统语言信息并进行设置
    [self getCurrentLanguageAndSet];
    
    //1.通过xib创建控制器
    ViewController *VC = [[ViewController alloc] init];
    //2.设置根控制器为window的根控制器
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = naviVC;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

#pragma mark --- get current language (zh-Hans or en or fr)
-(void)getCurrentLanguageAndSet
{
    NSArray * languageArr = [NSLocale preferredLanguages];
    NSLog(@"%@",languageArr);
    
    //获取当前系统语言并设置首次使用哪个语言文件
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Language"]) {
        NSArray * languageArr = [NSLocale preferredLanguages];
        NSString * currentLanguage = [languageArr objectAtIndex:0];
        
        if([currentLanguage hasPrefix:@"zh-Hans"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"Language"];
        }else if([currentLanguage hasPrefix:@"en"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"Language"];
        }else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"fr" forKey:@"Language"];
        }
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] hasPrefix:@"zh-Hans"])
        {
            [NSBundle setLanguage:@"zh-Hans"];
        }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] hasPrefix:@"en"])
        {
            [NSBundle setLanguage:@"en"];
        }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] hasPrefix:@"fr"])
        {
            [NSBundle setLanguage:@"fr"];
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
