//
//  graffitiTabBarController.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 08.04.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiTabBarController.h"
#import "graffitiCameraViewController.h"
#import "graffitiMapViewController.h"
#import "graffitiFeedTableViewController.h"
#import "graffitiSettingsViewController.h"
#import "Constants.h"

#import <CRGradientNavigationBar/CRGradientNavigationBar.h>

@interface graffitiTabBarController ()

@end

@implementation graffitiTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar setTranslucent:YES];
    [self.tabBar setBackgroundImage:[self imageFromColor:mainColor forSize:CGSizeMake(self.view.frame.size.width, 49) withCornerRadius:0]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    
    graffitiMapViewController * map = [[graffitiMapViewController alloc] init];
    graffitiFeedTableViewController *feed = [[graffitiFeedTableViewController alloc] init];
    
    UINavigationController *nCMap = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    [nCMap.navigationBar setTintColor:activeColor];
    [nCMap setViewControllers:@[feed]];
    [nCMap.navigationBar setTranslucent:NO];
    [nCMap setTitle:@"Graffiti"];
   // nCMap.navigationBar.barTintColor = mainColor;
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:@[gradientBrigtherColor, mainColor]];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    nCMap.navigationBar.titleTextAttributes = textAttributes;
    
    graffitiCameraViewController * camera = [[graffitiCameraViewController alloc] init];
    graffitiSettingsViewController * settings = [[graffitiSettingsViewController alloc] init];
    [nCMap.tabBarItem setTitle:NSLocalizedString(@"Discover", nil)];
    [nCMap.tabBarItem setImage:[[UIImage imageNamed:@"tabBarIconMap"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nCMap.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabBarIconMap"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [camera.tabBarItem setTitle:NSLocalizedString(@"Graffiti", nil)];
    [camera.tabBarItem setImage:[[UIImage imageNamed:@"tabBarIconSpray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [camera.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabBarIconSpray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [settings.tabBarItem setTitle:NSLocalizedString(@"Settings", nil)];
    [settings.tabBarItem setImage:[[UIImage imageNamed:@"tabBarIconUser"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [settings.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabBarIconUser"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    [self setViewControllers:@[nCMap, camera, settings]];
    
    
#warning To-change
    [self setSelectedIndex:0];
    
}

- (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
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
