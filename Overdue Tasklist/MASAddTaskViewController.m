//
//  MASAddTaskViewController.m
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "MASAddTaskViewController.h"

@interface MASAddTaskViewController ()

@end

@implementation MASAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
-(BOOL)wasDataEnteredCorrectly
{
    /// If the taskNameTextField or the taskDetailTextView are not empty... return YES
    if (self.taskNameTextField.text.length != 0 || self.taskDetailTextView.text.length != 0) {
        
        return YES;
    
    } else {

        /// If either filed is empty... show alert and return NO
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please make sure that all fields have been entered" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        
        return NO;
    }
}

-(void)AddTaskToSavedTasks
{
    /// Create instance of NSDictionary and load with values from textField, textView & date picked
    NSDictionary *dictionary = @{TASK_NAME: self.taskNameTextField.text, TASK_DETAIL : self.taskDetailTextView.text, TASK_DATE : self.taskDatePicker.date};
    
    /// Create mutableArray from the exsisting tasks in NSUserDefaults
    NSMutableArray *tasksAddedAsPropertyList =
            [[[NSUserDefaults standardUserDefaults] ///returns NSUserDefaults propertylist with current saved tasks
            arrayForKey:ADDED_TASK_TO_PLIST] ///get array from ADDED_TASK_TO_PLIST key in returned propertyList
                    mutableCopy]; ///make a mutable copy of the array to set it as the value of the mutableArray
    
    /// if tasksAddedAsPropertyList has not been created... create it.
    if (!tasksAddedAsPropertyList) {
        tasksAddedAsPropertyList = [[NSMutableArray alloc] init];
    }
    /// if already created... do this:
    ///add the dictionary to the tasksAddedAsPropertyList array
    [tasksAddedAsPropertyList addObject:dictionary];
    
    /// Set the tasksAddedAsPropertyList array as an object in the NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:tasksAddedAsPropertyList forKey:ADDED_TASK_TO_PLIST];
    
    /// Save the data to the NSUserDefault
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Action Button Methods

- (IBAction)cancelAddTaskButtonPressed:(UIBarButtonItem *)sender {
    
    [self.delegate didCancel];
}

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender {
    
    if ([self wasDataEnteredCorrectly] == YES) {
    
        MASTaskObject *newTaskObject = [self returnNewTaskObject];
        [self AddTaskToSavedTasks];
        [self.delegate addTaskObject:newTaskObject];
    }

}


#pragma mark - Helper Method

-(MASTaskObject *)returnNewTaskObject
{
    MASTaskObject *task = [[MASTaskObject alloc] init];
    
    task.title = self.taskNameTextField.text;
    task.detail = self.taskDetailTextView.text;
    task.date = self.taskDatePicker.date;
    task.completion = NO;
    
    return task;
}



#pragma mark - TextField & TextView Delegate Methods

/// TextFieldDelegate Method that dismiss the keyboard when the return key is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

/// TextViewDelegate Method that will dismiss the keyboard from the view when the user hits return
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /// if the user hits return (making an additional line)
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder]; ///resign the keyboard
        return NO; ///NO tells the TextView not to allow anymore text to be added
    }
    return YES; ///if return not pressed, YES tells the TextView to allow user to add text
}

@end
