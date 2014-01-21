//
//  ClassView.h
//  XML
//
//  Created by Caleb Freed on 12/22/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassThings.h"
#import "Class_details.h"
#import "AFNetworking.h"
#import "DetailsViewController.h"

@interface ClassView : UIViewController
{
    UIScrollView* scrollView;

}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ClassThings * passedClass;

@end
