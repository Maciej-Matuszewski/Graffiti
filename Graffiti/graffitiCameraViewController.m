//
//  graffitiCameraViewController.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 08.04.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiCameraViewController.h"

@interface graffitiCameraViewController ()

@property (nonatomic, retain) UIButton *tabBarButton;

@end

@implementation graffitiCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *buttonImage = [UIImage imageNamed:@"nrs_cam_record"];
    UIImage *highlightImage = [UIImage imageNamed:@"nrs_cam_record_pressed"];
    self.tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tabBarButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width*1.5, buttonImage.size.height*1.5);
    [self.tabBarButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.tabBarButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [self.tabBarButton setBackgroundColor:[UIColor whiteColor]];
    [self.tabBarButton.layer setCornerRadius:self.tabBarButton.frame.size.width/2];
    [self.tabBarButton setClipsToBounds:YES];
    [self.tabBarButton.layer setBorderColor:[UIColor purpleColor].CGColor];
    [self.tabBarButton.layer setBorderWidth:5];
    CGFloat heightDifference = self.tabBarButton.frame.size.height - self.tabBarController.tabBar.frame.size.height;
    if (heightDifference < 0)
        self.tabBarButton.center = self.tabBarController.tabBar.center;
    else
    {
        CGPoint center = self.tabBarController.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        self.tabBarButton.center = center;
    }
    [self.tabBarController.view addSubview:self.tabBarButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tabBarButton setHidden:NO];
    [self.tabBarItem setTitle:@""];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.tabBarButton setHidden:YES];
    [self.tabBarItem setTitle:NSLocalizedString(@"Graffiti", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
