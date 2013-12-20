//
//  Class_details.h
//  XML
//
//  Created by Caleb Freed on 12/19/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassThings;

@interface Class_details : NSManagedObject

@property (nonatomic, retain) NSString * crn;
@property (nonatomic, retain) NSString * discussion;
@property (nonatomic, retain) NSString * lecture;
@property (nonatomic, retain) NSString * lab;
@property (nonatomic, retain) ClassThings *info;

@end
