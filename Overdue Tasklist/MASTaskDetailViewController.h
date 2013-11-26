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

/// Create Protocol for passing change of completion back to taskTableVC
@protocol MASTaskDetailViewControllerDelegate <NSObject>

-(void)userChangedTaskCompletion;

@end

@interface MASTaskDetailViewController : UIViewController <MASEditTaskViewControllerDelegate>

@property (weak, nonatomic) id <MASTaskDetailViewControllerDelegate> delegate;

#pragma mark - UILabel Properties
@property (strong, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDetailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskStatus;

#pragma mark - Completed Properties
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *buttonImageView;


#pragma mark - Other Properties
@property (strong, nonatomic) MASTaskObject *currentTask;

#pragma mark - Action Buttons
- (IBAction)editTaskButtonPressed:(UIBarButtonItem *)sender;

- (IBAction)completionButtonPressed:(UIButton *)sender;
@end
