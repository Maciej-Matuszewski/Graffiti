//
//  AppDelegate.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 08.04.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "AppDelegate.h"

#import "Constants.h"

#import "graffitiTabBarController.h"

#import "graffitiLoginViewController.h"

#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"k6IKcaFdacdswPvUNFskVgfB1J3aR5rIpdkDtklv"
                  clientKey:@"iaViHftHc4cB0OUXfZ9TN6681fSMuKr6yvVursd9"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if(YES/*/[PFUser currentUser]//*/) self.window.rootViewController = [[graffitiTabBarController alloc] init];
    else
        self.window.rootViewController = [[graffitiLoginViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    
    [[UITabBar appearance] setTintColor:activeColor];
    [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : activeColor, NSFontAttributeName: [UIFont boldSystemFontOfSize:14]}forState:UIControlStateSelected];
    
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName:nonActiveColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
