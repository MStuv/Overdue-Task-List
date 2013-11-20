//
//  MASTaskDetailViewController.h
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASEditTaskViewController.h"
#import "MASTaskObject.h"

@interface MASTaskDetailViewController : UIViewController <MASEditTaskViewControllerDelegate>


#pragma mark - UILabel Properties
@property (strong, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDetailsLabel;

#pragma mark - Other Properties
@property (strong, nonatomic) MASTaskObject *currentTask;

#pragma mark - Action Buttons

- (IBAction)editTaskButtonPressed:(UIBarButtonItem *)sender;

@end
