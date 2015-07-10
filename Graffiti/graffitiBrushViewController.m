//
//  graffitiBrushViewController.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 08.07.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiBrushViewController.h"
#import "Constants.h"

@interface graffitiBrushViewController ()

@property (nonatomic, retain) UIView *previewColorView;

@property (nonatomic, retain) UISlider *sizeSlider;
@property (nonatomic, retain) UILabel *sizeLabel;

@end

@implementation graffitiBrushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:mainBackgroundColor];
    /*
    [self setPreviewColorView:[[UIView alloc] init]];
    [self.previewColorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.previewColorView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.previewColorView];
    [self.previewColorView.layer setCornerRadius:80];
    [self.previewColorView.layer setBorderWidth:4];
    [self.previewColorView.layer setBorderColor:mainColor.CGColor];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.previewColorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preview(160)]" options:0 metrics:nil views:@{@"preview":self.previewColorView}]];
  
    //*/
    
    
    
    UIButton *b1 = [self buttonWithColor:[UIColor redColor]];
    UIButton *b2 = [self buttonWithColor:[UIColor greenColor]];
    UIButton *b3 = [self buttonWithColor:[UIColor blueColor]];
    UIButton *b4 = [self buttonWithColor:[UIColor cyanColor]];
    UIButton *b5 = [self buttonWithColor:[UIColor yellowColor]];
    UIButton *b6 = [self buttonWithColor:[UIColor magentaColor]];
    UIButton *b7 = [self buttonWithColor:[UIColor orangeColor]];
    UIButton *b8 = [self buttonWithColor:[UIColor purpleColor]];
    UIButton *b9 = [self buttonWithColor:[UIColor brownColor]];
    UIButton *b10 = [self buttonWithColor:[UIColor blackColor]];
    UIButton *b11 = [self buttonWithColor:[UIColor grayColor]];
    UIButton *b12 = [self buttonWithColor:[UIColor whiteColor]];
    
    self.sizeLabel = [[UILabel alloc] init];
    [self.sizeLabel setText:[NSString stringWithFormat:@"Brush size: %d",(int)self.brushSize]];
    [self.sizeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.sizeLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.sizeLabel];
    
    [self setSizeSlider:[[UISlider alloc] init]];
    [self.sizeSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.sizeSlider setMinimumValue:5];
    [self.sizeSlider setMaximumValue:80];
    [self.sizeSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.sizeSlider];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:b2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==35)-[b2]-(==20)-[b5]-(==20)-[b8]-(==20)-[b11]-(>=40)-[slider]-(==15)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"b2":b2, @"b5":b5, @"b8":b8, @"b11":b11,@"slider":self.sizeSlider}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[b1]-(==20)-[b2]-(==20)-[b3]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"b1":b1,@"b2":b2,@"b3":b3}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[b1]-(==20)-[b2]-(==20)-[b3]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"b1":b4,@"b2":b5,@"b3":b6}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[b1]-(==20)-[b2]-(==20)-[b3]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"b1":b7,@"b2":b8,@"b3":b9}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[b1]-(==20)-[b2]-(==20)-[b3]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"b1":b10,@"b2":b11,@"b3":b12}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|" options:0 metrics:nil views:@{@"slider":self.sizeSlider}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-[slider]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"label":self.sizeLabel, @"slider":self.sizeSlider}]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.previewColorView setBackgroundColor:self.currentColor];
    
    [self.sizeLabel setText:[NSString stringWithFormat:@"Brush size: %d",(int)self.brushSize]];
    [self.sizeSlider setValue:self.brushSize];
}

- (UIButton *)buttonWithColor:(UIColor *)color{
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[[UIImage imageNamed:@"colorSpray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [button setTintColor:color];
    [button addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:button];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(80)]" options:0 metrics:nil views:@{@"button":button}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(80)]" options:0 metrics:nil views:@{@"button":button}]];
    [button setTransform:CGAffineTransformMakeScale(1.4, 1.4)];
    if ([color isEqual:[UIColor blackColor]]) {
#warning TO-DO
        
        
    }
    
    return button;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectColor:(UIButton*)button{
    
    self.returnColor(button.tintColor);
}

-(void)sliderValueChanged{
    self.brushSize = self.sizeSlider.value;
    self.returnSize(self.brushSize);
    
    [self.sizeLabel setText:[NSString stringWithFormat:@"Brush size: %d",(int)self.brushSize]];
}

@end
