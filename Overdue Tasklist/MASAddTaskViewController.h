//
//  MASAddTaskViewController.h
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTaskObject.h"

@protocol MASAddTaskViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)addTaskObject:(MASTaskObject *)taskObject;

@end

@interface MASAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>


@property (weak, nonatomic) id <MASAddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDetailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *taskDatePicker;


- (IBAction)cancelAddTaskButtonPressed:(UIButton *)sender;

- (IBAction)addTaskButtonPressed:(UIButton *)sender;
@end
