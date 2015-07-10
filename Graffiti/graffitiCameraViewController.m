//
//  graffitiCameraViewController.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 08.04.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiCameraViewController.h"
#import "graffitiPaintViewController.h"

#import "PBJVision.h"
#import "Constants.h"

#import <DBPrivacyHelper/UIViewController+DBPrivacyHelper.h>

#import <Parse/Parse.h>

@interface graffitiCameraViewController () <PBJVisionDelegate>

@property (nonatomic, retain) UIButton *tabBarButton;

@property(nonatomic, retain) IBOutlet UIView *previewView;
@property(nonatomic, retain) IBOutlet AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic, retain) graffitiPaintViewController *paintView;

@end

@implementation graffitiCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:mainBackgroundColor];
    
    [self prepareForButton];
    [self prepareForPhoto];
    
    UIButton *changeCameraButton = [[UIButton alloc] init];
    [changeCameraButton setImage:[UIImage imageNamed:@"cameraRotateButton"] forState:UIControlStateNormal];
    [changeCameraButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [changeCameraButton setBackgroundColor:mainColor];
    [changeCameraButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [changeCameraButton.layer setCornerRadius:20];
    [self.view addSubview:changeCameraButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==25)-[change(40)]" options:0 metrics:nil views:@{@"change":changeCameraButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[change(40)]-(==5)-|" options:0 metrics:nil views:@{@"change":changeCameraButton}]];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tabBarButton setHidden:NO];
    [self.tabBarItem setTitle:@""];
    PBJVision *vision = [PBJVision sharedInstance];
    [vision unfreezePreview];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.tabBarButton setHidden:YES];
    [self.tabBarItem setTitle:NSLocalizedString(@"Graffiti", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - checkPermission

- (BOOL)checkPermission:(NSString*)mediaType{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    } else if(authStatus == AVAuthorizationStatusDenied){
        return NO;
    } else if(authStatus == AVAuthorizationStatusRestricted){
        return NO;
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:nil];
        return NO;
    } else {
        return NO;
    }
    return NO;
}

#pragma mark - tabBarBigButton

- (void)prepareForButton{
    
    UIImage *buttonImage = [UIImage imageNamed:@"nrs_cam_record"];
    UIImage *highlightImage = [UIImage imageNamed:@"nrs_cam_record_pressed"];
    self.tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tabBarButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width*1.5, buttonImage.size.height*1.5);
    [self.tabBarButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.tabBarButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [self.tabBarButton setBackgroundColor:[UIColor whiteColor]];
    [self.tabBarButton.layer setCornerRadius:self.tabBarButton.frame.size.width/2];
    [self.tabBarButton setClipsToBounds:YES];
    [self.tabBarButton.layer setBorderColor:mainColor.CGColor];
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
    [self.tabBarButton addTarget:self action:@selector(takePhotoAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - PBJVision

- (void)prepareForPhoto{
    
    if ([self checkPermission:AVMediaTypeVideo]) {
        [[PBJVision sharedInstance] previewLayer];
        
        
        _previewView = [[UIView alloc] initWithFrame:self.view.frame];
        _previewView.backgroundColor = mainColor;
        [self.view addSubview:_previewView];
        _previewLayer = [[PBJVision sharedInstance] previewLayer];
        _previewLayer.frame = _previewView.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_previewView.layer addSublayer:_previewLayer];
        
        PBJVision *vision = [PBJVision sharedInstance];
        vision.delegate = self;
        vision.cameraDevice = PBJCameraDeviceBack;
        vision.cameraMode = PBJCameraModePhoto;
        vision.cameraOrientation = PBJCameraOrientationPortrait;
        vision.focusMode = PBJFocusModeContinuousAutoFocus;
        vision.outputFormat = PBJOutputFormatSquare;
        
        [vision startPreview];
        
    }else{
        [self showPrivacyHelperForType:DBPrivacyTypeCamera controller:^(DBPrivateHelperController *vc) {
        } didPresent:^{
        } didDismiss:^{
            if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)[self showPrivacyHelperForType:DBPrivacyTypeCamera];
        } useDefaultSettingPane:NO];
        
    }
}

- (void)takePhotoAction{
    [[PBJVision sharedInstance] capturePhoto];
}

-(void)changeCamera{
    
    PBJVision *vision = [PBJVision sharedInstance];
    
    if (vision.cameraDevice==PBJCameraDeviceBack)vision.cameraDevice = PBJCameraDeviceFront;
    else vision.cameraDevice = PBJCameraDeviceBack;
    
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error{
    
    UIImage *image = [UIImage imageWithData:[photoDict objectForKey:@"PBJVisionPhotoJPEGKey"]];
    
    self.paintView = [[graffitiPaintViewController alloc] init];
    [self.paintView setImage:[self imageByScalingAndCroppingForSize:self.view.frame.size withImage:image]];
    
    
    self.locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self startUpdateLocation];
    //[self presentViewController:self.paintView animated:NO completion:nil];
}


#pragma mark - location

-(void)startUpdateLocation{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [_locationManager requestAlwaysAuthorization];
    } else {
        [_locationManager startUpdatingLocation];
    }
    
}

- (void)stopUpdateLocation{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [self.paintView setPoint:point];
    
    [self.locationManager stopUpdatingLocation];
    
    [self presentViewController:self.paintView animated:NO completion:nil];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
            [manager requestWhenInUseAuthorization];
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
            
            [self showPrivacyHelperForType:DBPrivacyTypeLocation controller:^(DBPrivateHelperController *vc) {
            } didPresent:^{
            } didDismiss:^{
                if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)[self showPrivacyHelperForType:DBPrivacyTypeLocation];
            } useDefaultSettingPane:NO];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
