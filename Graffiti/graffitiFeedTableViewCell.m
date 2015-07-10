//
//  graffitiFeedTableViewCell.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 09.07.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiFeedTableViewCell.h"
#import "Constants.h"
#import <EXPhotoViewer/EXPhotoViewer.h>


@implementation graffitiFeedTableViewCell
@synthesize imageView;

- (void)awakeFromNib {
    
    UIView *container = [[UIView alloc] init];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
    [container setClipsToBounds:YES];
    [self addSubview:container];
    [self setBackgroundColor:FlatBlackDark];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[container]-(==80)-|" options:0 metrics:nil views:@{@"container":container}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[container]-(==0)-|" options:0 metrics:nil views:@{@"container":container}]];
    
    [self setImageView:[[UIImageView alloc] init]];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [container addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageFullScreen)];
    [container addGestureRecognizer:tap];
    
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:@{@"imageView":self.imageView}]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:@{@"imageView":self.imageView}]];
    
    [self setLikeButton:[[UIButton alloc] init]];
    [self.likeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.likeButton setImage:[[UIImage imageNamed:@"cellLike"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.likeButton];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==40)]" options:0 metrics:nil views:@{@"button":self.likeButton}]];
    
    
    
    [self setCommentsButton:[[UIButton alloc] init]];
    [self.commentsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.commentsButton setImage:[[UIImage imageNamed:@"cellComments"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.commentsButton addTarget:self action:@selector(commentsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.commentsButton];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==40)]" options:0 metrics:nil views:@{@"button":self.commentsButton}]];
    
    [self setMapButton:[[UIButton alloc] init]];
    [self.mapButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mapButton setImage:[[UIImage imageNamed:@"cellMap"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.mapButton];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==40)]" options:0 metrics:nil views:@{@"button":self.mapButton}]];
    
    [self setMoreButton:[[UIButton alloc] init]];
    [self.moreButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.moreButton setImage:[[UIImage imageNamed:@"cellMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.moreButton];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(==40)]" options:0 metrics:nil views:@{@"button":self.moreButton}]];
    
    [self setAvatarView:[[UIImageView alloc] init]];
    [self.avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.avatarView setBackgroundColor:mainColor];
    [self.avatarView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.avatarView.layer setBorderWidth:1];
    [self.avatarView.layer setCornerRadius:30];
    [self addSubview:self.avatarView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container(>=200)]-(==10)-[avatar(==60)]-(==10)-|" options:0 metrics:nil views:@{@"container":container, @"avatar":self.avatarView}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[avatar(==60)]-(>=10)-[like(==40)]-[comments(==40)]-[map(==40)]-(==25)-[more(==40)]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"avatar":self.avatarView, @"like":self.likeButton, @"comments":self.commentsButton, @"map":self.mapButton, @"more":self.moreButton}]];
    
    UIView *sepparator = [[UIView alloc] init];
    [sepparator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [sepparator setBackgroundColor:mainBackgroundColor];
    [self addSubview:sepparator];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sepparator]|" options:0 metrics:nil views:@{@"sepparator":sepparator}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sepparator(==5)]|" options:0 metrics:nil views:@{@"sepparator":sepparator}]];
    
    
    /*
    
    [self setCommentsButton:[[UIButton alloc] init]];
    [self.commentsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.commentsButton setTitle:@"Comments" forState:UIControlStateNormal];
    [self.commentsButton setBackgroundColor:mainColorTransparent];
    [self.commentsButton addTarget:self action:@selector(commentsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentsButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    [self.commentsButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDragInside];
    [self.commentsButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.commentsButton addTarget:self action:@selector(buttonUp:) forControlEvents:UIControlEventTouchDragOutside];
    [container addSubview:self.commentsButton];
    
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[likeButton][commentsButton(likeButton)]|" options:0 metrics:nil views:@{@"likeButton":self.likeButton, @"commentsButton":self.commentsButton}]];
    
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]|" options:0 metrics:nil views:@{@"button":self.likeButton}]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(==50)]|" options:0 metrics:nil views:@{@"button":self.commentsButton}]];
    
    //*/
    
    /*
    [self setLabel:[[UILabel alloc] init]];
    [self.label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.label setText:@" Test"];
    [self.label setTextColor:[UIColor whiteColor]];
    [container addSubview:self.label];
    
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label(==40)]" options:0 metrics:nil views:@{@"label":self.label}]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:@{@"label":self.label}]];
    //*/
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)showImageFullScreen{
    NSLog(@"image");
    [EXPhotoViewer showImageFrom:self.imageView];
}

-(void)likeButtonAction:(UIButton*)button{
    
    [self.likeButton setUserInteractionEnabled:NO];
    
    if(![self.object[@"Likes"] containsObject:[PFUser currentUser]]){
        self.object[@"Likes"] = self.object[@"Likes"]?[self.object[@"Likes"] arrayByAddingObject:[PFUser currentUser]]:@[[PFUser currentUser]];
    }else{
        NSMutableArray *tempArray = [self.object[@"Likes"] mutableCopy];
        [tempArray removeObject:[PFUser currentUser]];
        self.object[@"Likes"] = tempArray;
    }
    
    [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [self.likeButton setUserInteractionEnabled:YES];
        [self.likeButton setTintColor:[self.object[@"Likes"] containsObject:[PFUser currentUser]]?mainColor:activeColor];
    }];
}

-(void)commentsButtonAction:(UIButton*)button{
    self.openChat(self.object);
}

-(void)mapButtonAction:(UIButton*)button{
    self.openMap(self.object);
}

-(void)moreButtonAction:(UIButton*)button{
    self.openChat(self.object);
}

@end
