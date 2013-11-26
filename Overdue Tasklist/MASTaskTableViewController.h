//
//  MASTaskTableViewController.h
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASAddTaskViewController.h"
#import "MASTaskDetailViewController.h"
#import "MASTaskObject.h"


/// Define statements put into the .pch file

/// Conform to addTaskVCDelegate, taskDetailVCDelegate & UITableViewDelegate and UITableViewDataSource
@interface MASTaskTableViewController : UIViewController <MASAddTaskViewControllerDelegate, MASTaskDetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *taskName;
@property (strong, nonatomic) NSString *taskDetail;
@property (strong, nonatomic) NSDate *taskDate;


@property (strong, nonatomic) NSMutableArray *taskObjects;


- (IBAction)addNewTaskButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)reorderCellsButtonPressed:(UIBarButtonItem *)sender;
@end
