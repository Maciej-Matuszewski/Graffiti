//
//  graffitiBrushViewController.h
//  Graffiti
//
//  Created by Maciej Matuszewski on 08.07.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface graffitiBrushViewController : UIViewController

@property (nonatomic, retain)UIColor *currentColor;

@property (strong,nonatomic) void(^returnColor)(UIColor *);

@property (strong,nonatomic) void(^returnSize)(float);

@property float brushSize;

@end
