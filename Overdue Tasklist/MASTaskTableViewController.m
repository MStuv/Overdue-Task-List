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


#pragma mark - Lazy Instantiation of taskObject
-(NSMutableArray *)taskObjects
{
    /// if the mutableArray has not been created... create it!
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    return _taskObjects;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.translucent = NO;
    
    /// Set tableView dataSource & delegate to self
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
 
    /// LOAD SAVED DATA:
        /// Create instance of NSArray and set to value of NSUserDefaults at the key: ADDED_TASK_TO_PLIST
    NSArray *tasksAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_TO_PLIST];
    
    /// Iterate through the array
    for (NSDictionary *dictionary in tasksAsPropertyLists) {
        
        /// pull out a MASTaskObject object set with the taskObjectForDictionary: helper method.
        MASTaskObject *taskObject = [self taskObjectForDictionary:dictionary];
        
        /// add the taskObject to the taskObjects array
        [self.taskObjects addObject:taskObject];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
///PASSING DATA to AddTaskVC: Passing the info that TaskTableVC is the delegate for AddTaskVC
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
        if ([segue.destinationViewController isKindOfClass:[MASAddTaskViewController class]]) {
            /// create instance of MASAddTaskVC (destination VC)
            MASAddTaskViewController *addTaskVC = segue.destinationViewController;
            /// set current VC as the delegate for addTaskVC
            addTaskVC.delegate = self;
        }
    }
    
///PASSING DATA to TaskDetailVC: From Data at IndexPath to Display In DetailVC
    /// Sender is of a NSIndexPath
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        /// destinationVC is MASTaskDetailVC
        if ([segue.destinationViewController isKindOfClass:[MASTaskDetailViewController class]]) {
            
            /// Create instance of taskDetailVC and set the value to the destinationVC segue
            MASTaskDetailViewController *taskDetailVC = segue.destinationViewController;
            
            /// Create an instance of NSIndexPath and set the value to the value of sender
            NSIndexPath *path = sender;
            
            /// Create an instance of MASTaskObject - set value to the task in the array current row
            MASTaskObject *selectedTaskObject = self.taskObjects[path.row];
            
            /// set the current object as the value of the destinationVCtaskDetailVC's currentTask property
            taskDetailVC.currentTask = selectedTaskObject;
            
            /// set currentVC as the delegate for taskDetailVC
            taskDetailVC.delegate = self;
        }
    }
}




#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /// Return the number of rows in the section based on the amount of items in the taskObject array.
    return [self.taskObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    /// Create instance of taskObject and set to the task in the array at the indexPath row
    MASTaskObject *task = [self.taskObjects objectAtIndex:indexPath.row];
    
    /// Set textLabel to the taskObject's title property
    cell.textLabel.text = task.title;
    
    /// Create instance of NSDateFormatter and set the format the date will display as in the cell
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"cccc - MMMM d, yyyy"];
    
    /// Set the detailTextLabel to a formatted string version of the taskObject's date property
    cell.detailTextLabel.text = [formatter stringFromDate:task.date];
    
/// Set color of taskCell
    /// Change textLabel & detailTextLabel background to clear or it will look weird.
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    /// if the taskDate IS NOT OVERDUE...
    if ([self isTaskDateGreaterThanCurrentDate:task.date and:[NSDate date]] == YES) {
            /// ... and if the task IS NOT COMPLETE
            if (task.completion == NO) {
                // change the cell background to yellow
                cell.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:0.100];
                /// change to the todo image and set the highlighted image
                cell.imageView.image = [UIImage imageNamed:@"todo.png"];
                cell.imageView.highlightedImage = [UIImage imageNamed:@"todo_highlighted.png"];
                
            ///else if taskDate IS NOT OVERDUE and if the task completion is YES
            } else if (task.completion == YES) {
                // change the cell background to green
                cell.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.100];
                /// change to the completed image and set the highlighted image
                cell.imageView.image = [UIImage imageNamed:@"completed.png"];
                cell.imageView.highlightedImage = [UIImage imageNamed:@"completed_highlighted.png"];
        }
            /// else if the taskDate IS OVERDUE and the task IS complete
            } else if (([self isTaskDateGreaterThanCurrentDate:task.date and:[NSDate date]] == NO) && (task.completion) == YES) {
                // change cell background to green
                cell.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:0.100];
                /// change to the completed image and set the highlighted image
                cell.imageView.image = [UIImage imageNamed:@"completed.png"];
                cell.imageView.highlightedImage = [UIImage imageNamed:@"completed_highlighted.png"];
      
            /// else if the taskDate IS OVERDUE and IS NOT complete
            } else {
                cell.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.100];
                /// change to the overdue image and set the highlighted image
                cell.imageView.image = [UIImage imageNamed:@"overdue.png"];
                cell.imageView.highlightedImage = [UIImage imageNamed:@"overdue_highlighted.png"];
        }
    /// Allow Control for Reordering Cells to show
    cell.showsReorderControl = YES;
    
    return cell;
}


/// ALLOW CELLS TO BE REORDERED: If return of YES, tells tableView to allow the cells to be moved
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


/** CELL IS A MOVING: Method provides data regarding where the Cell was and where it is going. This data is used to rearrange the Cell's position in the taskObjects array and then presist it in NSUserDefaults **/
- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath{
    
    /// create instance of taskObject and set to the task in the array at the FROM row
    MASTaskObject *task = [self.taskObjects objectAtIndex:fromIndexPath.row];
    
    /// remove current task from taskObjects array at the FROM row
    [self.taskObjects removeObjectAtIndex:fromIndexPath.row];
    
    /// add current task to the taskObjects array at the TO row
    [self.taskObjects insertObject:task atIndex:toIndexPath.row];
    
    /// Call helper method that saves tasks to NSUserDefaults
    [self saveTasks];
    }



#pragma mark - TableView Delegate Methods
/// Override to support custom action when accessoryButton is tapped
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    /// Push to MASTaskDetailVC
    [self performSegueWithIdentifier:@"pushToDetail" sender:indexPath];
}


///WHEN USER SELECTS ROW: Change currentTask's completion property and presist data to NSUserDefaults via helper method.
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
        
        /// call helper method to save changed task to NSUserDefaults
        [self saveTasks];
        
        /// remove the row that the user is deleting
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark - Action Buttons

- (IBAction)addNewTaskButtonPressed:(UIBarButtonItem *)sender {
}


- (IBAction)reorderCellsButtonPressed:(UIBarButtonItem *)sender {
        /// if user IS NOT currently in editing mode
    if ([self.tableView isEditing] == NO) {
            /// turn on editing
            [self.tableView setEditing:YES animated:YES];
            /// change 'Reorder' button to 'Done'
            [sender setTitle:@"Done"];
            /// set color of 'done' button to gray
            [sender setTintColor:[UIColor grayColor]];
        
        /// if user IS currently in editing mode
    } else {
            /// turn of editing
            [self.tableView setEditing:NO animated:YES];
            /// change 'Done' back to 'Reorder'
            [sender setTitle:@"Reorder"];
            /// restore color back to original default system blue
            /// **** you would think Apple would have a "defaultColor" that could be call. But since they don't... I set it manually with the 'colorWithHue:saturation:brightness:alpha:' method
            [sender setTintColor:[UIColor colorWithHue:0.587 saturation:1.000 brightness:1.000 alpha:1.000]];
    }
}




#pragma mark - MASAddTaskViewController Delegate Methods

-(void)didCancel
{
    /// Using dismissViewControllerAnimated:competion: because segue is a modal
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)addTaskObject:(MASTaskObject *)taskObject
{
    //[self taskObjects];
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



#pragma mark - MASTaskDetailViewController Delegate Methods

/// delegate method is called from taskDetailVC
-(void)userChangedTaskCompletion
{
    /// use helper method to save task when delegate method is called
    [self saveTasks];
    /// reload table's cell data
    [self.tableView reloadData];
}



#pragma mark - Helper Method

-(void)saveTasks
{
    /// create a mutableArray that will presist the tasks to the NSUserDefaults
    NSMutableArray *savedTaskObjectData = [[NSMutableArray alloc] init];
    
    /// enumerate through the taskObjects in the taskObjects array
    for (MASTaskObject *taskObject in self.taskObjects) {
        
        /// add the dictionary that is returned from the taskObjectAsAPropertyList: helper method
        [savedTaskObjectData addObject:[self taskObjectAsAPropertyList:taskObject]];
    }
    /// create instance of the UserDefaults and set the savedTaskObjectData array at the ADD_TASK_TO_PLIST as an object in the UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:savedTaskObjectData forKey:ADDED_TASK_TO_PLIST];
    
    /// Synchronize(save) the data to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/// SAVING: Helper method to return a dictionary object containing the properties of the MASTaskObject.
-(NSDictionary *)taskObjectAsAPropertyList:(MASTaskObject *)taskObject
{
    NSDictionary *dictionary = @{TASK_NAME : taskObject.title, TASK_DETAIL : taskObject.detail, TASK_DATE : taskObject.date, TASK_COMPLETION : @(taskObject.completion)};
    
    return dictionary;
}


/// LOADING: Helper method to return a MASTaskObject containing properties of a MASTaskObject that was saved in the passed dictionary
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


///UPDATE COMPLETION STATUS: Helper method that will remove/insert the task in the taskObject array when user updates completion status
-(void)updateCompletionOfTask:(MASTaskObject *)task forIndexPath:(NSIndexPath *)indexPath
{
    /// Remove the previous version of task from the array at the indexPath's row
    [self.taskObjects removeObjectAtIndex:indexPath.row];

    /// Insert the current version of task into the array at the indexPath's row
    [self.taskObjects insertObject:task atIndex:indexPath.row];

    /// call helper method to save changed task to NSUserDefaults
    [self saveTasks];
    
    /// reload tableView data - refreshing the tableView's view
    [self.tableView reloadData];
}


@end
