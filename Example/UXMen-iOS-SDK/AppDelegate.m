//
//  AppDelegate.m
//  UXMen-iOS-SDK
//
//  Created by git-erdinc-bakir on 07/07/2019.
//  Copyright (c) 2019 git-erdinc-bakir. All rights reserved.
//

#import <UXMen_iOS_SDK/UXMenAPI.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    NSString *appId = @"317d2f3db37008eb936687bfe565759d29788adf045be1a9f64ccece44cd4edd";
    NSString *secret = @"ee977d551f7ee4fb5e56c2393338b2ab31f04e1be6dc46507d2cfa4469870b7a";
    
    [UXMenAPI.shared startTracking:self.window];
    [UXMenAPI.shared configure:appId andSecretKey:secret];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
