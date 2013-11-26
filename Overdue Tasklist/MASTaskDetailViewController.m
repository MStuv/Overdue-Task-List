//
//  MASTaskDetailViewController.m
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "MASTaskDetailViewController.h"
#import "MASEditTaskViewController.h"

@interface MASTaskDetailViewController ()

@end

@implementation MASTaskDetailViewController

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
    
    /// Call helper method to load data into view
    [self loadDataToView];
}

/// Method called when taskDetailVC is going to be removed
-(void)viewWillDisappear:(BOOL)animated
{
    /// call delegate method set in taskTableVC to reload tableView
    [self.delegate userChangedTaskCompletion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/// Passing Data to VCs through Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
/// Passing Data to the EditTaskVC
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        if ([segue.destinationViewController isKindOfClass:[MASEditTaskViewController class]]) {
            MASEditTaskViewController *editTaskVC = segue.destinationViewController;
            
            /// set current task from currentVC to the currentTask in destinationVC
            editTaskVC.currentTask = self.currentTask;
            
            /// set currentVC as the delegate for destinationVC
            editTaskVC.delegate = self;
        }
    }
}



#pragma mark - MASEditTaskViewController Delegate Methods
-(void)didSaveEditedTask:(MASTaskObject *)editedTask
{
    [self loadDataToView];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Action Methods
///WHEN USER PRESSES BUTTON: Change currentTask's completion property and presist data to NSUserDefaults via helper method.
- (IBAction)completionButtonPressed:(UIButton *)sender {
    
    [sender setHighlighted:YES];
   
        /// if completion is NO...
        if (self.currentTask.completion == NO) {
            /// ...make it YES
            self.currentTask.completion = YES;
            
            /// else it must be YES...
        } else {
            ///... so make it NO
            self.currentTask.completion = NO;
        }
    /// call helper method to update background color & buttonImage
    [self determineColorAndGraphic];
}
-(void)editTaskButtonPressed:(UIBarButtonItem *)sender
{
    /// Push to MASEditTaskVC
    [self performSegueWithIdentifier:@"EditTaskDetails" sender:sender];

    
}



#pragma mark - Helper Methods
/// LOAD/RELOAD DATA ON VIEW
-(void)loadDataToView
{
//    /// Set title of NavigationBar
//    self.navigationItem.title = self.currentTask.title;
    
    /// Set labels with data passed from the taskTableVC
    self.taskNameLabel.text = self.currentTask.title;
    self.taskDetailsLabel.text = self.currentTask.detail;
    
    [self determineColorAndGraphic];
    
    NSDate *date = self.currentTask.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"cccc\nMMMM d, yyyy"];
    //[formatter setDateFormat:@"MM-dd-yyyy"];
    
    self.taskDateLabel.text = [formatter stringFromDate:date];
}


/// IS TASK OVERDUE? Helper method to return a BOOL base on comparing dates
-(BOOL)isTaskDateGreaterThanCurrentDate:(NSDate *)taskDate and:(NSDate *)currentDate
{
    double seconds1 = [taskDate timeIntervalSince1970];
    double seconds2 = [currentDate timeIntervalSince1970];
    
    if (seconds1 < seconds2) {
        return NO;
        
    } else {
        return YES;
    }
}


/// When button is pressed, this method determines what color background and what image to display on the view.
-(void)determineColorAndGraphic
{
    /// if the taskDate IS NOT OVERDUE...
    if ([self isTaskDateGreaterThanCurrentDate:self.currentTask.date and:[NSDate date]] == YES) {
        /// ... and if the task IS NOT COMPLETE
        if (self.currentTask.completion == NO) {
            // change the cell background to yellow
            self.backgroundImageView.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:0.100];
            
            /// change to the todo image and set the highlighted image
            [self.buttonImageView setImage:[UIImage imageNamed:@"todo.png"] forState:UIControlStateNormal];
            [self.buttonImageView setImage:[UIImage imageNamed:@"todo _highlighted.png"] forState:UIControlStateHighlighted];
            
            /// change taskStatus Label - text & color
            self.taskStatus.text = @"To Do";
            self.taskStatus.textColor = [UIColor colorWithRed:0.980 green:0.918 blue:0.067 alpha:1.000];
            
            ///else if taskDate IS NOT OVERDUE and if the task completion is YES
        } else if (self.currentTask.completion == YES) {
            // change the cell background to green
            self.backgroundImageView.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.100];
            
            /// change to the completed image and set the highlighted image
            [self.buttonImageView setImage:[UIImage imageNamed:@"completed.png"] forState:UIControlStateNormal];
            [self.buttonImageView setImage:[UIImage imageNamed:@"completed_highlighted.png"] forState:UIControlStateHighlighted];
            
            /// change taskStatus Label - text & color
            self.taskStatus.text = @"Completed";
            self.taskStatus.textColor = [UIColor colorWithRed:0.322 green:0.725 blue:0.278 alpha:1.000];

        }
        /// else if the taskDate IS OVERDUE and the task IS complete
    } else if (([self isTaskDateGreaterThanCurrentDate:self.currentTask.date and:[NSDate date]] == NO) && (self.currentTask.completion) == YES) {
            // change cell background to green
            self.backgroundImageView.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.100];
        
            /// change to the completed image and set the highlighted image
            [self.buttonImageView setImage:[UIImage imageNamed:@"completed.png"] forState:UIControlStateNormal];
            [self.buttonImageView setImage:[UIImage imageNamed:@"completed_highlighted.png"] forState:UIControlStateHighlighted];
        
            /// change taskStatus Label - text & color
            self.taskStatus.text = @"Completed";
            self.taskStatus.textColor = [UIColor colorWithRed:0.322 green:0.725 blue:0.278 alpha:1.000];
        
        /// else if the taskDate IS OVERDUE and IS NOT complete
    } else {
            self.backgroundImageView.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.100];
        
            /// change to the overdue image and set the highlighted image
            [self.buttonImageView setImage:[UIImage imageNamed:@"overdue.png"] forState:UIControlStateNormal];
            [self.buttonImageView setImage:[UIImage imageNamed:@"overdue_highlighted.png"] forState:UIControlStateHighlighted];
        
            /// change taskStatus Label - text & color
            self.taskStatus.text = @"Overdue";
            self.taskStatus.textColor = [UIColor colorWithRed:0.839 green:0.137 blue:0.161 alpha:1.000];
    }
}

@end
