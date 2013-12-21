//
//  AddCourseViewController.h
//  XML
//
//  Created by Caleb Freed on 12/16/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "TBXML+HTTP.h"
#import "Class_details.h"
#import "ClassThings.h"


@class AddCourseViewController;

@protocol AddCourseViewControllerDelegate <NSObject>

- (void) AddCourseFinished:(AddCourseViewController*) controller;

@end


@interface AddCourseViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL deptloaded;
    BOOL classloaded;
    BOOL sectionsloaded;
    NSInteger deptRow;

}

@property (strong, nonatomic) id <AddCourseViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSMutableArray *dept;
@property (strong, nonatomic) NSMutableArray *classes;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITableView *results;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *crns;
@property (strong, nonatomic) NSMutableArray *selectedCrns;
@property (strong, nonatomic) NSMutableArray *selectedSections;
@property (strong, nonatomic) NSString *selectedDept;
@property (strong, nonatomic) NSString *selectedCourse;



@end
