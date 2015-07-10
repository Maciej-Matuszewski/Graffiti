//
//  graffitiCameraViewController.h
//  Graffiti
//
//  Created by Maciej Matuszewski on 08.04.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface graffitiCameraViewController : UIViewController<CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *locationManager;

@end
