//
//  MCFolderTableViewController.h
//  MemoCamera
//
//  Created by Peerames on 1/14/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


#import "MCAppDelegate.h"
#import "Album.h"
#import "Album_.h"
#import "Photo.h"
#import "WSAssetPicker.h"
#import "Photo_.h"
#import "MCAlbumViewController.h"

typedef void (^DidSelectImagesForAlbumBlock)(NSArray *assets);

@interface MCFolderTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) WSAssetPickerController *pickerController;

@property (copy) DidSelectImagesForAlbumBlock didSelectImagesForAlbumBlock;

- (IBAction)onClickEdit:(id)sender;
- (IBAction)onClickAdd:(id)sender;

@end
