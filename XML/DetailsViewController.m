//
//  DetailsViewController.m
//  XML
//
//  Created by Caleb Freed on 12/29/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

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
    self.className.text = [NSString stringWithFormat:@"%@ %@", _currClass.department, _currClass.classNum];
    self.section.text = _currClass.section;
    self.professor.text = [NSString stringWithFormat:@"%@ %@", _currClass.details.instructorF, _currClass.details.instructorL];
    self.days.text = _currClass.details.days;
    self.times.text = [NSString stringWithFormat:@"%@ - %@", _currClass.details.startTime, _currClass.details.endTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
