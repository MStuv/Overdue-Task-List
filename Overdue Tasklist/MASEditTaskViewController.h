//
//  MASEditTaskViewController.h
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTaskObject.h"


/// Created Protocol to pass data back to taskDetailVC
@protocol MASEditTaskViewControllerDelegate <NSObject>

-(void)didSaveEditedTask:(MASTaskObject *)editedTask;

@end

@interface MASEditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) id <MASEditTaskViewControllerDelegate> delegate;

#pragma mark - IBOutlet Properies
@property (strong, nonatomic) IBOutlet UITextField *editTaskLabel;
@property (strong, nonatomic) IBOutlet UITextView *editTaskDetailLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *editDatePicker;

/// Used for setTaskComplete
@property (strong, nonatomic) IBOutlet UIButton *setTaskStatusImage;
@property (strong, nonatomic) IBOutlet UILabel *setTaskStatusLabel;

@property (strong, nonatomic)MASTaskObject *currentTask;

#pragma mark - Button/Action Methods
- (IBAction)saveButtonPressed:(id)sender;

- (IBAction)setTaskStatusButtonPressed:(UIButton *)sender;


@end
