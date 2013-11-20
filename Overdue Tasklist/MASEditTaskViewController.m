//
//  MASEditTaskViewController.m
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "MASEditTaskViewController.h"

@interface MASEditTaskViewController ()

@end

@implementation MASEditTaskViewController

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
    self.editTaskLabel.text = self.currentTask.title;
    self.editTaskDetailLabel.text = self.currentTask.detail;
    
    self.editDatePicker.date = self.currentTask.date;
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods



@end
