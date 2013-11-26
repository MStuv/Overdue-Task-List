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
    
    ///Hide back button from the navigationBar
    [self.navigationItem setHidesBackButton:YES];
    
    /// Set labels & dataPicker with data passed from the taskTableVC
    self.editTaskLabel.text = self.currentTask.title;
    self.editTaskDetailLabel.text = self.currentTask.detail;
    self.editDatePicker.date = self.currentTask.date;
    
    /// if completion is YES...
    if (self.currentTask.completion == YES) {
        /// ...Set Button Image to Completed!
        self.setTaskStatusImage.imageView.image = [UIImage imageNamed:@"completed.png"];
        /// set label - text & color
        self.setTaskStatusLabel.text = @"Completed";
        self.setTaskStatusLabel.textColor = [UIColor colorWithRed:0.322 green:0.725 blue:0.278 alpha:1.000];
        
    /// else it must be NO...
    } else {
        ///... Set Button Image to grayed Complete Image
        self.setTaskStatusImage.imageView.image = [UIImage imageNamed:@"completed_highlighted.png"];
        /// change taskStatus Label - text & color
        self.setTaskStatusLabel.text = @"not complete";
        self.setTaskStatusLabel.textColor = [UIColor colorWithRed:0.667 green:0.671 blue:0.671 alpha:1.000];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




#pragma mark - Action/Button Method

- (IBAction)saveButtonPressed:(id)sender {
    
    /// Save Changes to currentTask properties
    self.currentTask.title = self.editTaskLabel.text;
    self.currentTask.detail = self.editTaskDetailLabel.text;
    self.currentTask.date = self.editDatePicker.date;

    /// implement delegate method to save data through TasDetailVC
    [self.delegate didSaveEditedTask:self.currentTask];
}

- (IBAction)setTaskStatusButtonPressed:(UIButton *)sender {
    
    /// if completion is NO...
    if (self.currentTask.completion == NO) {
        /// ...make it YES & set Button Image to Completed!
        self.currentTask.completion = YES;
        [self.setTaskStatusImage setImage:[UIImage imageNamed:@"completed.png"] forState:UIControlStateNormal];
        
        /// set label - text & color
        self.setTaskStatusLabel.text = @"Completed";
        self.setTaskStatusLabel.textColor = [UIColor colorWithRed:0.322 green:0.725 blue:0.278 alpha:1.000];
        
        /// else it must be YES...
    } else {
        ///... so make it NO & set Button Image to Grayed Complete!
        self.currentTask.completion = NO;
        [self.setTaskStatusImage setImage:[UIImage imageNamed:@"completed_highlighted.png"] forState:UIControlStateNormal];
        
        /// set label text & color
        self.setTaskStatusLabel.text = @"not complete";
        self.setTaskStatusLabel.textColor = [UIColor colorWithRed:0.667 green:0.671 blue:0.671 alpha:1.000];
    }
}


@end
