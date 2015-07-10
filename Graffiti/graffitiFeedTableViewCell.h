//
//  graffitiFeedTableViewCell.h
//  Graffiti
//
//  Created by Maciej Matuszewski on 09.07.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface graffitiFeedTableViewCell : UITableViewCell

@property (nonatomic)UIImageView *imageView;

@property (nonatomic, retain) UIButton *likeButton;
@property (nonatomic, retain) UIButton *commentsButton;
@property (nonatomic, retain) UIButton *mapButton;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UIImageView *avatarView;
@property (nonatomic, retain) PFObject *object;
@property (strong,nonatomic) void(^openChat)(PFObject *object);
@property (strong,nonatomic) void(^openMap)(PFObject *object);

@end
