//
//  XLAppDelegate.h
//  XML
//
//  Created by Caleb Freed on 12/12/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//For core data
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;


@end
