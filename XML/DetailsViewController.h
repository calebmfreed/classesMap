//
//  DetailsViewController.h
//  XML
//
//  Created by Caleb Freed on 12/29/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassThings.h"
#import "Class_details.h"

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *professor;
@property (weak, nonatomic) IBOutlet UILabel *section;
@property (weak, nonatomic) IBOutlet UILabel *days;
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (strong, nonatomic) ClassThings * currClass;



@end
