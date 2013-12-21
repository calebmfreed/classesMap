//
//  Classes.m
//  XML
//
//  Created by Caleb Freed on 12/16/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "Classes.h"

@interface Classes ()

@end

@implementation Classes
@synthesize loading, managedObjectContext;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated{
    loaded = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //For the plus button
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addButtonPressed)];
    self.navigationItem.leftBarButtonItem = addButton;

    //Loading stuff and activity indicator
    loaded = NO;
    loading.hidesWhenStopped = YES;
    //[loading startAnimating];
    _dept = [[NSMutableArray alloc]init];
    _classes= [[NSMutableArray alloc] init];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ClassThings" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *temparray;
    temparray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [_classes addObjectsFromArray:temparray];
    
    NSLog(@"View loaded: %@",_classes);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) traverseElement:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSLog(@"%@",[TBXML elementName:element]);
        
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            NSLog(@"%@->%@ = %@",  [TBXML elementName:element],
                  [TBXML attributeName:attribute],
                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));
}

- (void)addButtonPressed{
    [self performSegueWithIdentifier:@"addClass" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    {
        ClassThings *things = [_classes objectAtIndex:indexPath.row];
        NSLog(@"whats in here?:%@ %@", things.classNum, things.section);
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@: %@", things.department, things.classNum, things.section];

    }
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
//Return from adding a course. In this function I need to fetch the details of the coruse from the website and then store
//  them into CoreData managed object.
- (void) AddCourseFinished:(AddCourseViewController*) controller{
    loaded = NO;
    NSLog(@"Returned CRNS: %@", controller.selectedCrns);
    NSLog(@"Returned Course: %@", controller.selectedCourse);
    NSLog(@"Returned Dept: %@", controller.selectedDept);
    NSLog(@"Returned Sections: %@", controller.selectedSections);
    [self dismissViewControllerAnimated:YES completion:nil];
    //If there was a selected course in the added view, then reload the tableview
    if([controller.selectedCrns count] != 0)
    {
        int i = 0;
        for(id thing in controller.selectedCrns)
        {
            [self getDetails:controller.selectedDept crn:thing classNum:controller.selectedCourse section:controller.selectedSections[i]];
            
            i++;

        }
    }
}

- (void) getDetails: (NSString*) dept crn: (NSString*)crn classNum:(NSString*)classNum section: (NSString*) section
{
 
    //XML Success block
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
        {
            TBXMLElement *root = tbxmlDocument.rootXMLElement;
            //THis line helps to get to the departments
            TBXMLElement *meetings = [TBXML childElementNamed:@"meetings" parentElement:root];
            TBXMLElement *meeting = [TBXML childElementNamed:@"meeting" parentElement:meetings];
            TBXMLElement *type = [TBXML childElementNamed:@"type" parentElement:meeting];
            TBXMLElement *start = type->nextSibling;
            TBXMLElement *end = start->nextSibling;
            TBXMLElement *days = end->nextSibling;
            TBXMLElement *room = days->nextSibling;
            TBXMLElement *buldingName = room->nextSibling;
            TBXMLElement *instructors = [TBXML childElementNamed:@"instructors" parentElement:meeting];


            
            id delegate = [[UIApplication sharedApplication] delegate];
            self.managedObjectContext = [delegate managedObjectContext];
            ClassThings *classInfo = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"ClassThings"
                                      inManagedObjectContext:managedObjectContext];
            classInfo.classNum = classNum;
            classInfo.department = dept;
            classInfo.crn = crn;
            classInfo.section = section;
            Class_details *cdetails = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Class_details"
                                       inManagedObjectContext:managedObjectContext];
            cdetails.type = [TBXML attributeValue:type->firstAttribute];
            cdetails.startTime = [TBXML textForElement:start];
            cdetails.endTime = [TBXML textForElement:end];
            cdetails.days = [TBXML textForElement:days];
            cdetails.roomNumber = [TBXML textForElement:room];
            cdetails.building = [TBXML textForElement:buldingName];
            cdetails.instructorF = [TBXML attributeValue:instructors->firstChild->firstAttribute];
            cdetails.instructorL = [TBXML attributeValue:instructors->firstChild->firstAttribute->next];
            cdetails.info = classInfo;
            classInfo.details = cdetails;

            NSLog(@"Instructor:%@, %@",cdetails.instructorF,cdetails.instructorL);
            NSLog(@"type:%@",cdetails.type);
            NSLog(@"start:%@",cdetails.startTime);
            NSLog(@"end:%@",cdetails.endTime);
            NSLog(@"days:%@",cdetails.days);
            NSLog(@"room:%@",cdetails.roomNumber);
            NSLog(@"building:%@",cdetails.building);
            
            NSError *error;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            [_classes addObject:classInfo];

        }
        //Set the department as loaded and reload the components
        dispatch_async(dispatch_get_main_queue(), ^{
            //[loading stopAnimating];
            loaded=YES;
            [self.tableView reloadData];
        });
        NSLog(@"Done loading details");
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    //URL to get departments
    //http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring.xml
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://courses.illinois.edu/cisapp/explorer/schedule/2014/spring/%@/%@/%@.xml",dept,classNum,crn]]
                                      success:successBlock
                                      failure:failureBlock];
    
//Core data saving stuff
//    id delegate = [[UIApplication sharedApplication] delegate];
//    self.managedObjectContext = [delegate managedObjectContext];
//    NSManagedObjectContext *context = [self managedObjectContext];
//    ClassThings *classInfo = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"ClassThings"
//                              inManagedObjectContext:managedObjectContext];
//    classInfo.classNum = classNum;
//    classInfo.department = dept;
//    classInfo.crn = crn;
}


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [[segue destinationViewController] setDelegate: self];
    
}



@end
