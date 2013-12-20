//
//  ClassThings.h
//  XML
//
//  Created by Caleb Freed on 12/19/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Class_details;

@interface ClassThings : NSManagedObject

@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * classNum;
@property (nonatomic, retain) Class_details *details;

@end
