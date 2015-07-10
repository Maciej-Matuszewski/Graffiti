//
//  graffitiPaintViewController.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 09.04.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiPaintViewController.h"
#import "UIImageView+Draw.h"
#import "Constants.h"

#import <QBPopupMenu.h>
#import "UIViewController+CWPopup.h"

#import "graffitiBrushViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface graffitiPaintViewController ()

@property (nonatomic,strong) UIButton *optionsButton;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *saveButton;

@end

@implementation graffitiPaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:mainBackgroundColor];
    
    self.useBlurForPopup = YES;
    
    [self createInterface];
    [self prepareImage];
    [self.myImage setImage:self.image];
    [self.myImage startDrawing];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - interface

- (void)createInterface{
    
    [self setMyImage:[[UIImageView alloc] initWithFrame:self.view.frame]];
    [self.myImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.myImage];
    
    
    self.saveButton = [[UIButton alloc] init];
    [self.saveButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.saveButton setBackgroundColor:mainColor];
    [self.saveButton setImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton.layer setCornerRadius:20];
    [self.view addSubview:self.saveButton];
    
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backButton setBackgroundColor:mainColor];
    [self.backButton setImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton.layer setCornerRadius:20];
    [self.view addSubview:self.backButton];
    
    self.optionsButton = [[UIButton alloc] init];
    [self.optionsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.optionsButton setBackgroundColor:mainColor];
    [self.optionsButton setImage:[UIImage imageNamed:@"brush"] forState:UIControlStateNormal];
    [self.optionsButton.layer setCornerRadius:20];
    [self.optionsButton addTarget:self action:@selector(brushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.optionsButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.optionsButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[options(40)]" options:0 metrics:nil views:@{@"options":self.optionsButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[back(40)]" options:0 metrics:nil views:@{@"back":self.backButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[save(40)]-(==10)-|" options:0 metrics:nil views:@{@"save":self.saveButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==10)-[back(40)]-(>=10)-[options(40)]-(>=10)-[save(40)]-(==10)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"save":self.saveButton, @"options":self.optionsButton, @"back":self.backButton}]];
    
}

-(void)prepareImage{
    if (self.image.size.width>self.view.frame.size.width) {
        float k = self.view.frame.size.width/self.image.size.width;
        UIGraphicsBeginImageContext(CGSizeMake(self.image.size.width*k, self.image.size.height*k));
        [self.image drawInRect:CGRectMake(0,0,self.image.size.width*k,self.image.size.height*k)];
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
}


-(void)save{
    
    [self.optionsButton setEnabled:NO];
    [self.backButton setEnabled:NO];
    [self.saveButton setEnabled:NO];
    
    [SVProgressHUD show];
    
    //[self.myImage save];
    
    NSData* data = UIImageJPEGRepresentation([self.myImage returnImage], 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    // Save the image to Parse
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            
            PFObject *newGraffiti = [PFObject objectWithClassName:@"Graffiti"];
            newGraffiti[@"Location"] = self.point;
            newGraffiti[@"Photo"]=imageFile;
            newGraffiti[@"Author"]=[PFUser currentUser];
            [newGraffiti saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                [SVProgressHUD dismiss];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];

            
        }
    }];
    
    
    
}

-(void)backButtonAction{
    QBPopupMenuItem *brush = [QBPopupMenuItem itemWithTitle:@"Back" target:self action:@selector(backAction)];
    QBPopupMenuItem *eraser = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"eraseIcon"] target:self action:@selector(rubberAction)];
    QBPopupMenuItem *reset = [QBPopupMenuItem itemWithTitle:@"Reset" target:self action:@selector(resetAction)];
    
    
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:@[brush,eraser,reset]];
    
    [popupMenu showInView:self.view targetRect:self.backButton.frame animated:YES];
}

-(void)brushAction{
    
    graffitiBrushViewController *gBVC = [[graffitiBrushViewController alloc] init];
    [gBVC setCurrentColor:[self.myImage getColor]];
    [gBVC setBrushSize:[self.myImage getSize]];
    
    gBVC.returnSize = ^void(float size){
        [self.myImage setBrush:size];
    };
    
    gBVC.returnColor =^void(UIColor *color){
        
        [self.myImage setColor:color];
        if (self.popupViewController != nil) {
            [self dismissPopupViewControllerAnimated:YES completion:nil];
        }
    };
    
    [self presentPopupViewController:gBVC animated:YES completion:nil];
    
}

-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rubberAction{
    [self.myImage selectRubber];
}

-(void)resetAction{
    [self.myImage resetImage];
}

@end
