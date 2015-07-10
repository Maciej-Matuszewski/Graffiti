//
//  graffitiCommentsViewController.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 10.07.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiCommentsViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Constants.h"

@interface graffitiCommentsViewController ()


@property (nonatomic, retain) JSQMessagesBubbleImage *incomingBubble;
@property (nonatomic, retain) JSQMessagesBubbleImage *outgoingBubble;
@property (nonatomic, retain) JSQMessagesAvatarImage *incomingAvatar;
@property (nonatomic, retain) JSQMessagesAvatarImage *outgoingAvatar;
@property (nonatomic, retain) NSArray *commentsArray;

@end

@implementation graffitiCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:mainBackgroundColor];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    self.commentsArray = [[NSArray alloc] init];
    
    self.senderId = [[PFUser currentUser] objectId];
    self.senderDisplayName = [[PFUser currentUser] username];
    
    [self setIncomingBubble:[[[[JSQMessagesBubbleImageFactory alloc] init] initWithBubbleImage:[UIImage imageNamed:@"bubble"] capInsets:UIEdgeInsetsMake(0, 0, 0, 0)] incomingMessagesBubbleImageWithColor:mainColor]];
    [self setOutgoingBubble:[[[[JSQMessagesBubbleImageFactory alloc] init] initWithBubbleImage:[UIImage imageNamed:@"bubble"] capInsets:UIEdgeInsetsMake(0, 0, 0, 0)] outgoingMessagesBubbleImageWithColor:FlatYellowDark]];

    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(50, 50);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(50, 50);
    [self setIncomingAvatar:[JSQMessagesAvatarImageFactory avatarImageWithPlaceholder:[UIImage imageNamed:@"userDefault"] diameter:100]];
    [self setOutgoingAvatar:[JSQMessagesAvatarImageFactory avatarImageWithPlaceholder:[UIImage imageNamed:@"userDefault"] diameter:100]];
    
    [self.inputToolbar.contentView.rightBarButtonItem setTitleColor:mainColor forState:UIControlStateNormal];
    [self.inputToolbar.contentView.textView setTintColor:mainColor];
    [self.inputToolbar.contentView setBackgroundColor:gradientBrigtherColor];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    [self loadComments];
    
}

-(void)loadComments{
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"Graffiti" equalTo:self.graffiti];
    [query includeKey:@"Author"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.commentsArray = objects;
            [self.collectionView reloadData];
            [self scrollToBottomAnimated:YES];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //self.collectionView.collectionViewLayout.springinessEnabled = YES;
    
    [self.collectionView reloadData];
    [self scrollToBottomAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Database

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.commentsArray.count;
}

#pragma mark - CellContent

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    return cell;
    
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:[[self.commentsArray objectAtIndex:indexPath.row] createdAt]];
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[JSQMessage alloc] initWithSenderId:[[self.commentsArray objectAtIndex:indexPath.row][@"Author"] objectId]
                              senderDisplayName:[[self.commentsArray objectAtIndex:indexPath.row][@"Author"] username]
                                           date:[[self.commentsArray objectAtIndex:indexPath.row] createdAt]
                                           text:[self.commentsArray objectAtIndex:indexPath.row][@"Text"]];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [[self.commentsArray objectAtIndex:indexPath.row][@"Author"] isEqual:[PFUser currentUser]]?self.outgoingBubble:self.incomingBubble;
    
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.commentsArray objectAtIndex:indexPath.row][@"Author"] isEqual:[PFUser currentUser]]?self.outgoingAvatar:self.incomingAvatar;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [[NSAttributedString alloc] initWithString:[[self.commentsArray objectAtIndex:indexPath.row][@"Author"] username]];
}

#pragma mark - Layout

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
    
}

-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                  layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
    
}

#pragma mark - sendingMessage

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [SVProgressHUD show];
    [button setUserInteractionEnabled:NO];
    PFObject *newComment = [[PFObject alloc] initWithClassName:@"Comments"];
    newComment[@"Author"]=[PFUser currentUser];
    newComment[@"Text"]=text;
    newComment[@"Graffiti"]=self.graffiti;
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [SVProgressHUD dismiss];
        [button setUserInteractionEnabled:YES];
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self finishSendingMessageAnimated:YES];
        
        [self loadComments];
        
    }];
}

@end
