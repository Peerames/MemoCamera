//
//  MCAppDelegate.h
//  MemoCamera
//
//  Created by Peerames on 1/14/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFolderTableViewController.h"

@interface MCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
