//
//  graffitiPaintViewController.h
//  Graffiti
//
//  Created by Maciej Matuszewski on 09.04.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface graffitiPaintViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *myImage;

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) PFGeoPoint *point;

@end
