//
//  MCAlbumViewController.h
//  MemoCamera
//
//  Created by Peerames on 2/21/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album_.h"
#import "Photo_.h"

@interface MCAlbumViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSIndexPath *albumIndexPath;

@end
