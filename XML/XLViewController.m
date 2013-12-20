//
//  XLViewController.m
//  XML
//
//  Created by Caleb Freed on 12/12/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "XLViewController.h"

@interface XLViewController ()

@end

@implementation XLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Create a success block to be called when the async request completes
    _dept = [[NSMutableArray alloc]init];
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
        {
            TBXMLElement *root = tbxmlDocument.rootXMLElement;
            TBXMLElement *thing = tbxmlDocument.rootXMLElement->firstChild->nextSibling->nextSibling->firstChild;
            TBXMLElement *next;
            while (thing->nextSibling){
                //NSLog(@"%@", [TBXML elementName:thing]);
                //NSLog(@"%@", [TBXML attributeName:thing->firstAttribute->next]);
                //NSLog(@"%@", [TBXML attributeValue:thing->firstAttribute->next]);
                [_dept addObject:[TBXML attributeValue:thing->firstAttribute->next]];
//                next = thing->nextSibling;
//                NSLog(@"%@", [TBXML elementName:next]);
//                NSLog(@"%@", [TBXML attributeName:next->firstAttribute->next]);
//                NSLog(@"%@", [TBXML attributeValue:next->firstAttribute->next]);
                thing=thing->nextSibling;
            }
            
            NSLog(@"%@", _dept);

            //NSLog(@"%@", [TBXML valueOfAttributeNamed:@"subject" forElement:tbxmlDocument.rootXMLElement]);
            //NSLog(@"%@", [TBXML childElementNamed:@"subjects" parentElement:thing]);
        }

            //[self traverseElement:tbxmlDocument.rootXMLElement];
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://courses.illinois.edu/cisapp/explorer/schedule/2013/spring.xml"]
                                      success:successBlock
                                      failure:failureBlock];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
