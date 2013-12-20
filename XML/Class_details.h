//
//  Class_details.h
//  XML
//
//  Created by Caleb Freed on 12/20/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassThings;

@interface Class_details : NSManagedObject

@property (nonatomic, retain) NSString * crn;
@property (nonatomic, retain) NSString * days;
@property (nonatomic, retain) NSString * instructor;
@property (nonatomic, retain) NSString * roomNumber;
@property (nonatomic, retain) NSString * building;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) ClassThings *info;

@end
