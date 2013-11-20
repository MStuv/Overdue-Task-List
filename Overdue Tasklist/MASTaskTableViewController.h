//
//  MASTaskTableViewController.h
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASAddTaskViewController.h"
#import "MASTaskObject.h"


/// Define statements put in the .pch file

@interface MASTaskTableViewController : UITableViewController <MASAddTaskViewControllerDelegate>

@property (strong, nonatomic) NSString *taskName;
@property (strong, nonatomic) NSString *taskDetail;
@property (strong, nonatomic) NSDate *taskDate;


@property (strong, nonatomic) NSMutableArray *taskObjects;


- (IBAction)addNewTaskButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)reorderCellsButtonPressed:(UIBarButtonItem *)sender;
@end
