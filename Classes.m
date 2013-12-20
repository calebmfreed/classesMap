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
@synthesize loading;

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
    [loading startAnimating];
    _dept = [[NSMutableArray alloc]init];
    _classes= [[NSMutableArray alloc] init];
    //[self getClasses:@"ECE"];
    //[self getDepartments];
    NSLog(@"View loaded");
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
            while (depts->nextSibling){
                //This line gets the departments
                [_dept addObject:[TBXML attributeValue:depts->firstAttribute->next]];

                depts=depts->nextSibling;
            }
        
        }
        NSLog(@"%@", _dept);
        
        loaded = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [loading stopAnimating];
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
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
        {
            //Doc Root
            TBXMLElement *root = tbxmlDocument.rootXMLElement;
            TBXMLElement *classes = root->firstChild->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->nextSibling->firstChild;
            NSLog(@"classes:%@", [TBXML elementName:classes]);
            //Loads up classes with the names
            while (classes->nextSibling){
                //This line gets the classes into the NSString classes
                [_classes addObject:[TBXML attributeValue:classes->firstAttribute->next]];
                classes=classes->nextSibling;
            }
        }
        NSLog(@"classes prop: %@", _classes);
        
        loaded = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [loading stopAnimating];
        });
        
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
    return [_dept count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(loaded == YES)
    {
        cell.textLabel.text = [_dept objectAtIndex:indexPath.row];
        NSLog(@"putting into cell:%@",[_dept objectAtIndex:indexPath.row]);

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
    NSLog(@"Returned CRNS: %@", controller.selectedCrns);
    NSLog(@"Returned Course: %@", controller.selectedCourse);
    NSLog(@"Returned Dept: %@", controller.selectedDept);

    

    [self dismissViewControllerAnimated:YES completion:nil];
}


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [[segue destinationViewController] setDelegate: self];
    
}



@end
