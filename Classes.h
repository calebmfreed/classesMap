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

@interface Classes : UITableViewController{
    BOOL loaded;
}
@property (strong, nonatomic) NSMutableArray * dept;
@property (strong, nonatomic) NSMutableArray *classes;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;


@end
