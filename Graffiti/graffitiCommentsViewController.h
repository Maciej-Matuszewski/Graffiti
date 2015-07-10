//
//  graffitiCommentsViewController.h
//  Graffiti
//
//  Created by Maciej Matuszewski on 10.07.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import <Parse/Parse.h>

@interface graffitiCommentsViewController : JSQMessagesViewController

@property (nonatomic, retain) PFObject *graffiti;


@end
