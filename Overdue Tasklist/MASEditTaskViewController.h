//
//  MASEditTaskViewController.h
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTaskObject.h"

@protocol MASEditTaskViewControllerDelegate <NSObject>

-(NSDictionary *)didSaveEditedTask;

@end

@interface MASEditTaskViewController : UIViewController

@property (weak, nonatomic) id <MASEditTaskViewControllerDelegate> delegate;

#pragma mark - UILabel Properies

@property (strong, nonatomic) IBOutlet UITextField *editTaskLabel;
@property (strong, nonatomic) IBOutlet UITextView *editTaskDetailLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *editDatePicker;

@property (strong, nonatomic) MASTaskObject *currentTask;

@end
