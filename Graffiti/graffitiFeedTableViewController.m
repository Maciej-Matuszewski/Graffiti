//
//  graffitiFeedTableViewController.m
//  Graffiti
//
//  Created by Maciej Matuszewski on 09.07.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "graffitiFeedTableViewController.h"
#import "graffitiFeedTableViewCell.h"
#import "graffitiCommentsViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
#import <Parse/Parse.h>

@interface graffitiFeedTableViewController ()

@property (nonatomic, retain) NSArray *graffitiArray;

@end

@implementation graffitiFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Graffiti"];
    
    [self setGraffitiArray:[[NSArray alloc] init]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView registerClass:[graffitiFeedTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view setBackgroundColor:mainBackgroundColor];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    [self.tableView setAllowsSelection:NO];
    [self.tableView setDelaysContentTouches:NO];
    //[self.tableView setPagingEnabled:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Graffiti"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.graffitiArray = objects;
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.graffitiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    graffitiFeedTableViewCell *cell = [[graffitiFeedTableViewCell alloc] init];//(graffitiFeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if( cell == NULL){
        cell = [[graffitiFeedTableViewCell alloc] init];
        
    }
    [cell awakeFromNib];
    
    
    PFFile *imageFile = [self.graffitiArray objectAtIndex:indexPath.row][@"Photo"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:nil];

    cell.object = [self.graffitiArray objectAtIndex:indexPath.row];
    [cell.likeButton setTintColor:[cell.object[@"Likes"] containsObject:[PFUser currentUser]]?mainColor:activeColor];
    
    cell.openChat =^void(PFObject *pfObject){
        graffitiCommentsViewController *commentsVC = [[graffitiCommentsViewController alloc] init];
        [commentsVC setHidesBottomBarWhenPushed:YES];
        [commentsVC setGraffiti:pfObject];
        [self.navigationController pushViewController:commentsVC animated:YES];
    };
    cell.openMap =^void(PFObject *pfObject){
        UIViewController *vc =[[UIViewController alloc] init];
        [vc.view setBackgroundColor:FlatRed];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.tableView.frame.size.height-48;
}


@end
