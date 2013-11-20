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
    
    /// Set labels with data passed from the taskTableVC
    NSLog(@"%@", [self.currentTask class]);
    self.taskNameLabel.text = self.currentTask.title;
    self.taskDetailsLabel.text = self.currentTask.detail;
    
    NSDate *date = self.currentTask.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"cccc\nMMMM d, yyyy"];
    //[formatter setDateFormat:@"MM-dd-yyyy"];
    
    self.taskDateLabel.text = [formatter stringFromDate:date];
    
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
            
            editTaskVC.currentTask = self.currentTask;
            
            editTaskVC.delegate = self;
        }
    }
}


#pragma mark - MASEditTaskViewController Delegate Methods
-(void)didSave
{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
