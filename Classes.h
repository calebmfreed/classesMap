//
//  Classes.h
//  XML
//
//  Created by Caleb Freed on 12/16/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "TBXML+HTTP.h"
#import "AddCourseViewController.h"
#import "ClassThings.h"
#import "Class_details.h"
#import "ClassView.h"
#import "XLAppDelegate.h"

@interface Classes : UITableViewController{
    BOOL loaded;
}
@property (strong, nonatomic) NSMutableArray * dept;
@property (strong, nonatomic) NSMutableArray *classes;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSString * lat;
@property (nonatomic, strong) NSString * lon;




@end
