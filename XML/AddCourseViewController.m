//
//  AddCourseViewController.m
//  XML
//
//  Created by Caleb Freed on 12/16/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "AddCourseViewController.h"

@interface AddCourseViewController ()

@end

@implementation AddCourseViewController


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
    
    //Initialize the loaded variables to NO
    deptloaded = NO;
    classloaded = NO;
    sectionsloaded = NO;
    
    //Set the table view delegates
    self.results.dataSource = self;
    self.results.delegate = self;
    
    //Set up the Navigation Bar buttons with DONE button and "add a class" title
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@"Add a Class"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [buttonCarrier setRightBarButtonItem:rightButton];
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    [_navBar setItems:barItemArray];
    
    //Set the colors of the bar and text
    _navBar.barTintColor = [UIColor blackColor];
    [self.navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //Initialize the properties
    _dept = [[NSMutableArray alloc]init];
    _classes= [[NSMutableArray alloc] init];
    _sections = [[NSMutableArray alloc] init];
    _crns = [[NSMutableArray alloc] init];
    _selectedCrns = [[NSMutableArray alloc] init];
    _selectedCourse = [[NSString alloc] init];
    _selectedDept = [[NSString alloc] init];
    _selectedSections = [[NSMutableArray alloc] init];

    //Get the departments
    [self getDepartments];
    //[self getClasses:@"ABE"];
    //[self getCourseSections:@"ECE" course:@"110"];
    
    
    
	// Do any additional setup after loading the view.
}

- (void) getDepartments
{
    //XML Success block
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
        {
            TBXMLElement *root = tbxmlDocument.rootXMLElement;

            //THis line helps to get to the departments
            TBXMLElement *depts = root->firstChild->nextSibling->nextSibling->firstChild;
            while (depts){
                //This line gets the departments and puts them in the property array
                [_dept addObject:[TBXML attributeValue:depts->firstAttribute->next]];
                
                depts=depts->nextSibling;
            }
            
        }
        //Set the department as loaded and reload the components
        deptloaded = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            //[loading stopAnimating];
            [_picker reloadAllComponents];
        });
        NSLog(@"Done loading depts");
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    //URL to get departments
    //http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring.xml
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring.xml"]
                                      success:successBlock
                                      failure:failureBlock];
}
- (void) getClasses:(NSString *) department
{
    //XML Success block
    //Clear the classes array for new class
    [_classes removeAllObjects];
    NSLog(@"In get classes");
    //Success block
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        NSLog(@"In success block for classes");
        if (tbxmlDocument.rootXMLElement)
        {
            //Doc Root
            TBXMLElement *root = tbxmlDocument.rootXMLElement;
            //Old way of getting the coruses
            //TBXMLElement *classes = root->firstChild->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->firstChild;
            //Gets the coruses child element
            TBXMLElement *classes = [TBXML childElementNamed:@"courses" parentElement:root];
            NSLog(@"classes:%@", [TBXML elementName:classes]);
            //Loads up classes with the numbers of the classes in the given department
            classes = classes->firstChild;
            while (classes){
                //This line gets the classes into the NSString classes
                [_classes addObject:[TBXML attributeValue:classes->firstAttribute->next]];
                classes=classes->nextSibling;
            }
            //Set the class loaded BOOL and reload the picker component for it
            classloaded = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_picker selectRow:0 inComponent:1 animated:YES];

                [self.picker reloadComponent:1];
            });

        }
        NSLog(@"classes prop: %@", _classes);
        

        
        NSLog(@"Done getting classes");
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    //URL to get departments
    //http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring.xml
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring/%@.xml",department]]
                                      success:successBlock
                                      failure:failureBlock];
}

- (void) getCourseSections:(NSString *) department course: (NSString *)course
{
    //XML Success block
    //Clear both the sections and crns arrays
    [_sections removeAllObjects];
    [_crns removeAllObjects];

    NSLog(@"In get sections");
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        NSLog(@"In success block for sections");
        if (tbxmlDocument.rootXMLElement)
        {
            //Doc Root
            TBXMLElement *root = tbxmlDocument.rootXMLElement;
            //Old way of getting classes
            //TBXMLElement *classes = root->firstChild->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->firstChild;
            //Gets the child named sections
            TBXMLElement *crns = [TBXML childElementNamed:@"sections" parentElement:root];
            //NSLog(@"sections:%@", [TBXML elementName:classes]);
            
            //Loads up courses with the names
            crns = crns->firstChild;

            while (crns){
                //This line gets the classes into the NSString classes
                //Adds the values to the CRNS and Sections arrays
                [_crns addObject:[TBXML attributeValue:crns->firstAttribute->next]];
                [_sections addObject: [TBXML textForElement:crns]];
                NSLog(@"Text: %@", [TBXML textForElement:crns]);
                crns=crns->nextSibling;
            }
            
            //classloaded = YES;
            //Sets the sections loaded variable and reloads the tableview in the main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                sectionsloaded = YES;

                [_results reloadData];
            });
            
        }
        NSLog(@"classes crns prop: %@", _crns);
        NSLog(@"classes sections prop: %@", _sections);

        
        
        
        NSLog(@"Done getting classes");
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    //URL to get departments
    //http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring.xml
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring/%@/%@.xml",department,course]]
                                      success:successBlock
                                      failure:failureBlock];
}

// returns the number of 'columns' to display, one for the depts and one for the courses
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component,
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if(component == 0)
    {
        return [_dept count];
    }
    else if(classloaded == YES && component == 1)
    {
        return [_classes count]+1;
    }
    else{
        return 1;
    }
}

//Gets the titles from all of the arrays for depts and classes
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if(deptloaded == YES && component == 0)
    {
        return [_dept objectAtIndex:row];

    }
    //Want to put this at the top of the row. But needs work.
    else if(component == 1 && row == 0)
    {
        return @"Select Course";
    }
    else if(classloaded == YES && component == 1)
    {
        return [_classes objectAtIndex:row-1];
    }
    else if (classloaded == NO && component == 1){
        return @"Select Dept";
    }
    else
    {
        return @"loading...";
    }
}

//If select a department, then load the classes. If selected class, then load the sections
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    //The 0 component is for dept, ECE, ANTH, etc
    if(component == 0)
    {
        sectionsloaded = NO;
        deptRow = row;
        NSLog(@"Selected Dept:%@", [_dept objectAtIndex:row]);
        _selectedDept = [_dept objectAtIndex:row];
        [self getClasses:[_dept objectAtIndex:row]];
    }
    //The 1 component is for the class, 101, 110, etc
    else if(component == 1 && classloaded == YES && row != 0)
    {
        [self getCourseSections: [_dept objectAtIndex:deptRow] course:[_classes objectAtIndex:row-1]];
        _selectedCourse = [_classes objectAtIndex:row-1];
        NSLog(@"pickerview comp1: %@", [_classes objectAtIndex:row-1]);
    }
}

//************TABLEVIEW***************

//Only one section in the results tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//Returns the number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(sectionsloaded == YES)
    {
        return [_sections count];
    }
    else
    {
        return 1;
    }
}
//Puts the names of our sections
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"sectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(sectionsloaded == YES)
    {
        cell.textLabel.text = [_sections objectAtIndex:indexPath.row];
        //NSLog(@"putting into cell:%@",[_sections objectAtIndex:indexPath.row]);
        
    }
    else if(sectionsloaded == NO)
    {
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 10.0/14.0;
        cell.textLabel.text = @"Please select a department and course";
    }
    // Configure the cell...
    
    return cell;
}

//Section header to select all of the sections
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return @"Select all sections for the course";
}

//IF selected, then add to the selected CRNS array to return to the called view controller.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@ %@", _crns, _sections);
    [_selectedCrns addObject:[_crns objectAtIndex:indexPath.row]];
    [_selectedSections addObject:[_sections objectAtIndex:indexPath.row]];

    NSLog(@"Didselect:%@ %@", _selectedCrns, _selectedSections);
}
//If deselected, remove from the array to return
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_selectedCrns removeObjectIdenticalTo:[_crns objectAtIndex:indexPath.row]];
    [_selectedSections removeObjectIdenticalTo:[_sections objectAtIndex:indexPath.row]];

    NSLog(@"Selected CRNS after remove: %@ %@", _selectedCrns, _selectedSections);
}


- (void) dismissView
{
    [[self delegate] AddCourseFinished:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
