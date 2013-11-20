//
//  MASTaskTableViewController.m
//  Overdue Tasklist
//
//  Created by Mark Stuver on 11/11/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "MASTaskTableViewController.h"
#import "MASTaskDetailViewController.h"


@interface MASTaskTableViewController ()

@end

@implementation MASTaskTableViewController

#pragma mark - Lazy Instantiation of taskObject Property
-(NSMutableArray *)taskObjects
{
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    return _taskObjects;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /// Loading data from NSUserDefaults
    NSLog(@"%i", self.taskObjects.count);

    NSArray *tasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_TO_PLIST];
    
    /// iterate through the array
    for (NSDictionary *dictionary in tasksAsPropertyLists) {
        /// pull out a MASTaskObject object set with the spaceObjectForDictionary: helper method.
        MASTaskObject *taskObject = [self taskObjectForDictionary:dictionary];
        
        /// add the spaceObject to the
        [self.taskObjects addObject:taskObject];
    }
    NSLog(@"%i", [self.taskObjects count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
/// Passing Data to AddTaskVC: Passing the info that TaskTableVC is the delegate for AddTaskVC
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        if ([segue.destinationViewController isKindOfClass:[MASAddTaskViewController class]]) {

            MASAddTaskViewController *addTaskVC = segue.destinationViewController;
            addTaskVC.delegate = self;
        }
    }
    
    
/// Passing Data to TaskDetailVC: From Data at IndexPath to Display In DetailVC
    /// Sender is of a NSIndexPath
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        /// destinationVC is MASTaskDetailVC
        if ([segue.destinationViewController isKindOfClass:[MASTaskDetailViewController class]]) {
            
            /// Create instance of taskDetailVC and set the value to the destinationVC segue
            MASTaskDetailViewController *taskDetailVC = segue.destinationViewController;
            
            /// Create an instance of NSIndexPath and set the value to the value of sender
            NSIndexPath *path = sender;
            
            /// Create an instance of MASTaskObject
            MASTaskObject *selectedTaskObject;
            
            /// set the value of the MASTaskObject to the value of the object in the array at path.row
            selectedTaskObject = self.taskObjects[path.row];
            
            /// set the current object as the value of the taskDetailVC's currentTask property
            taskDetailVC.currentTask = selectedTaskObject;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.taskObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    MASTaskObject *task = [self.taskObjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = task.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"cccc - MMMM d, yyyy"];
    
    cell.detailTextLabel.text = [formatter stringFromDate:task.date];
    
/// Set color of cell
    /// if the taskDate IS NOT OVERDUE...
    if ([self isTaskDateGreaterThanCurrentDate:task.date and:[NSDate date]] == YES) {
            /// ... and if the task IS NOT COMPLETE
            if (task.completion == NO) {
                // change the cell background to yellow
                cell.backgroundColor = [UIColor yellowColor];
        
            ///... and if the task completion is YES
            } else if (task.completion == YES) {
                // change the cell background to green
                cell.backgroundColor = [UIColor greenColor];
            }
        
     /// else if the taskDate IS OVERDUE and the task IS complete
    } else if (([self isTaskDateGreaterThanCurrentDate:task.date and:[NSDate date]] == NO) && (task.completion) == YES) {
        // change cell background to green
        cell.backgroundColor = [UIColor greenColor];
    } else {
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark - TableView Delegate Methods
/// Override to support custom action when accessoryButton is tapped
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushToDetail" sender:indexPath];
}
/// WHEN USER SELECTS ROW: Change currentTask's competion and presist data to NSUserDefaults via helper method.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /// Create Instance of MASTaskObject and set value to task in array that is at the current row
    MASTaskObject *currentTask = [self.taskObjects objectAtIndex:indexPath.row];
    /// if completion is NO...
    if (currentTask.completion == NO) {
        /// ...make it YES
        currentTask.completion = YES;
    /// else it must be YES...
    } else {
        ///... so make it NO
        currentTask.completion = NO;
    }
    /// call helper method to update the completion of the task and presist it to NSUserDefaults
    [self updateCompletionOfTask:currentTask forIndexPath:indexPath];
}

/// CAN USER EDIT ROW: return YES to allow, return NO to not allow
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    /// Allow user to edit
    return YES;
}

/// EDITING ROW: Remove task from tableView and also remove from NSUserDefaults
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        /// remove current task from taskObjects array
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        /// create new array that will presist to the NSUserDefaults without the deleted task
        NSMutableArray *revisedSavedTaskObjectData = [[NSMutableArray alloc] init];
        
        /// enumerate through the taskObjects in the taskObjects array
        for (MASTaskObject *taskObject in self.taskObjects) {
            
            /// add the dictionary that is returned from the taskObjectAsAPropertyList: helper method
            [revisedSavedTaskObjectData addObject:[self taskObjectAsAPropertyList:taskObject]];
        }
        
        /// create instance of the UserDefaults and set the revisedSavedTaskObjectDate at the ADD_TASK_TO_PLIST as an object in the UserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:revisedSavedTaskObjectData forKey:ADDED_TASK_TO_PLIST];
        
        ///Save/Synchronize the data to the NSUserDefaults
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /// remove the row that the user is deleting
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark - Action Buttons

- (IBAction)addNewTaskButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)reorderCellsButtonPressed:(UIBarButtonItem *)sender {
    
    
}


#pragma mark - MASAddTaskViewController Delegate Methods

-(void)didCancel
{
    /// Using dismissViewControllerAnimated:competion: because segue is a modal
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addTaskObject:(MASTaskObject *)taskObject
{
    [self taskObjects];
    [self.taskObjects addObject:taskObject];
    
    /// Create mutableArray from the data that is saved in the NSUserDefaults
    NSMutableArray *taskObjectsAsPropertyLists =
                        /// returns a NSUserDefaults object
                        [[[NSUserDefaults standardUserDefaults]
                          /// gets the array at the ADDED_TASK_TO_PLIST key from the UserDefaults
                          arrayForKey:ADDED_TASK_TO_PLIST]
                          /// create a mutableCopy of the array from UserDefaults
                          mutableCopy];
    
    /// If the mutableArray is empty (NSUserDefaults is Empty)... create it
    if (!taskObjectsAsPropertyLists) {
        taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    }
    
    /// Load a NSDictionary with the taskObject's properties, using helper method that returns an NSDictionary
    [taskObjectsAsPropertyLists addObject:[self taskObjectAsAPropertyList:taskObject]];
    
    /// Set the dictionary at key: ADDED_TASK_TO_PLIST of the NSUserDefaults into the MutableArray
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_TO_PLIST];
    
    /// Synchronize will actually save the data that was set
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

#pragma mark - Helper Method

/// SAVING: Helper method to return a dictionary object containing the properties of the MASTaskObject.
-(NSDictionary *)taskObjectAsAPropertyList:(MASTaskObject *)taskObject
{
    NSDictionary *dictionary = @{TASK_NAME : taskObject.title, TASK_DETAIL : taskObject.detail, TASK_DATE : taskObject.date, TASK_COMPLETION : @(taskObject.completion)};
    
    return dictionary;
}

/// For LOADING: Helper method to return a MASTaskObject containing properties of a MASTaskObject that was saved in the passed dictionary
-(MASTaskObject *)taskObjectForDictionary:(NSDictionary *)dictionary
{
    MASTaskObject *taskObject = [[MASTaskObject alloc] initWithData:dictionary];
    
    return taskObject;
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

///UPDATE COMPLETION STATUS: Helper method that will persist (save) when user updates completion status
-(void)updateCompletionOfTask:(MASTaskObject *)task forIndexPath:(NSIndexPath *)indexPath
{
    /// Set task object equal to the task object at the current row
    task = [self.taskObjects objectAtIndex:indexPath.row];
    /// Create instance of NSDictionary
    NSDictionary *currentTaskDictionary;
    
    /// Create a mutableArray with the taskObjects that are stored in NSUserDefaults
    NSMutableArray *taskObjectsInAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_TO_PLIST] mutableCopy];
    
    /// enumerate through the saved NSUserDefaults dictionaries
    for (NSDictionary *dictionary in taskObjectsInAsPropertyList) {
        
        /// When the dictionary is found that matches the current task
        if ([task.title isEqualToString:dictionary[TASK_NAME]] && [task.detail isEqualToString:dictionary[TASK_DETAIL]] && [task.date isEqualToDate:dictionary[TASK_DATE]])
        {
            /// set the currentTaskDictionary to equal the dictionary that contains the saved task object
            currentTaskDictionary = dictionary;
            
            /// break the enumeration and go to the next code statement
            break;
        }
    }
        /// remove the dictionary that contains the currentTaskObject's data from the NSUserDefaults array
        [taskObjectsInAsPropertyList removeObject:currentTaskDictionary];
    
    /// Add the task back into the NSUserDefaults array using the 'taskObjectAsAPropertyList:' helper method
    [taskObjectsInAsPropertyList addObject:[self taskObjectAsAPropertyList:task]];
    
    /// Set the dictionary at key: ADDED_TASK_TO_PLIST of the NSUserDefaults into the MutableArray
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsInAsPropertyList forKey:ADDED_TASK_TO_PLIST];
    
    /// Synchronize(save) the data that was set
    [[NSUserDefaults standardUserDefaults] synchronize];

    /// reload tableView data - refreshing the tableView's view
    [self.tableView reloadData];
}


@end
