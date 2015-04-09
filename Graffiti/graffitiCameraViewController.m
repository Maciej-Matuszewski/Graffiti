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

@interface graffitiCameraViewController () <PBJVisionDelegate>

@property (nonatomic, retain) UIButton *tabBarButton;

@property(nonatomic, retain) IBOutlet UIView *previewView;
@property(nonatomic, retain) IBOutlet AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation graffitiCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self prepareForButton];
    [self prepareForPhoto];
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
    [self.tabBarButton addTarget:self action:@selector(takePhotoAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - PBJVision

- (void)prepareForPhoto{
    
    if ([self checkPermission:AVMediaTypeVideo]) {
        [[PBJVision sharedInstance] previewLayer];
        
        
        _previewView = [[UIView alloc] initWithFrame:self.view.frame];
        _previewView.backgroundColor = [UIColor redColor];
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
        //TO-DO
        /*[self showPrivacyHelperForType:DBPrivacyTypeCamera controller:^(DBPrivateHelperController *vc) {
        } didPresent:^{
        } didDismiss:^{
            if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)[self showPrivacyHelperForType:DBPrivacyTypeCamera];
        } useDefaultSettingPane:NO];
        //*/
    }
}

- (void)takePhotoAction{
    [[PBJVision sharedInstance] capturePhoto];
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error{
    
    UIImage *image = [UIImage imageWithData:[photoDict objectForKey:@"PBJVisionPhotoJPEGKey"]];
    
    graffitiPaintViewController *paintView = [[graffitiPaintViewController alloc] init];
    [paintView setImage:image];
    [self presentViewController:paintView animated:YES completion:^{
        
    }];
        
    /*
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] startUpdateLocation];
    }else{
        
        [self showPrivacyHelperForType:DBPrivacyTypeLocation controller:^(DBPrivateHelperController *vc) {
        } didPresent:^{
        } didDismiss:^{
            if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)[self showPrivacyHelperForType:DBPrivacyTypeLocation];
        } useDefaultSettingPane:NO];
        
    }
    
    UIImage *image = [UIImage imageWithData:[photoDict objectForKey:@"PBJVisionPhotoJPEGKey"]];
    image = [self squareImageWithImage:image scaledToSize:image.size.height>image.size.width?CGSizeMake(image.size.width, image.size.width):CGSizeMake(image.size.height, image.size.height)];
    
    NSData* data = UIImageJPEGRepresentation(image, 0.2f);
    
    if ([PFUser currentUser][@"photo"]) {
        PFObject *photo = [PFObject objectWithClassName:@"Photos"];
        photo[@"user"] = [PFUser currentUser];
        photo[@"photo"] = [PFUser currentUser][@"photo"];
        [photo saveInBackground];
    }
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    [[PFUser currentUser] setObject:imageFile forKey:@"photo"];
    [[PFUser currentUser] setObject:[NSDate date] forKey:@"lastActivation"];
    [[PFUser currentUser] saveInBackground];
    
    
    
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] revealVC] setFrontViewController:[[ezOnlineNavigationController alloc] init]];
     //*/
}


@end
