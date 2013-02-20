//
//  MCFolderTableViewController.m
//  MemoCamera
//
//  Created by Peerames on 1/14/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import "MCFolderTableViewController.h"

@interface MCFolderTableViewController () <WSAssetPickerControllerDelegate>{
    MCAppDelegate *appDlegate;
}

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation MCFolderTableViewController

@synthesize tblView;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext;
@synthesize pickerController;
@synthesize didSelectImagesForAlbumBlock;
@synthesize assetsLibrary = _assetsLibrary;

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:NSLocalizedString(@"Albums", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Inherite managed object context for fetchedResultController
    appDlegate = (MCAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDlegate.managedObjectContext;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [tblView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait) {
        NSLog(@"Orientation becoming Portrait");
        [self.tblView setScrollIndicatorInsets:UIEdgeInsetsMake(32, 0, 0, 0)];
        [self.tblView setContentInset:UIEdgeInsetsMake(32, 0, 0, 0)];
    }else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        NSLog(@"Orientation becoming Landscape");
        [self.tblView setScrollIndicatorInsets:UIEdgeInsetsMake(44, 0, 0, 0)];
        [self.tblView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    }
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    Album_ *album = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:album.name];
    
    //Image Thumbnail
    NSString *posterUrl = @"";
    if ([album.posterUrl length] > 0) {
        posterUrl = album.posterUrl;
    } else {
        Photo_ *photo = [[album.photosInAlbum allObjects] lastObject];
        posterUrl = photo.representUrl;
    }
    
    [cell.imageView setImage:[UIImage imageNamed:@"no_image"]];
    __block UIImageView *_imageView = cell.imageView;
    
    [self.assetsLibrary assetForURL:[NSURL URLWithString:posterUrl] resultBlock:^(ALAsset *asset) {
        [_imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error get album image %@", error);
    }];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //self.pickerController = [[WSAssetPickerController alloc] initWithDelegate:self withAlbumName:album.name];
    //[self presentViewController:self.pickerController animated:YES completion:NULL];
}

//Move cell and rearrange datasource.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return [self tableView:tableView canMoveRowAtIndexPath:proposedDestinationIndexPath] ? proposedDestinationIndexPath : sourceIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //Implement custom logic for move row. Default still work.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [self.tblView setEditing:editing animated:animated];
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tblView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    UITableView *tableView = self.tblView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tblView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tblView endUpdates];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Album" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateAdded" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:<#Predicate Format#>];
    //[fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![__fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}

#pragma mark - Methods

- (IBAction)onClickAdd:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Album", nil)
                                                        message:NSLocalizedString(@"Enter a name for this album." , nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Save", nil), nil];
    
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];

    UITextField *textField = [alertView textFieldAtIndex:0];
    [textField setPlaceholder:NSLocalizedString(@"Title", nil)];
    [textField setEnablesReturnKeyAutomatically:YES];
    [alertView show];
    
    [self setEditing:NO animated:YES];
}

- (IBAction)onClickEdit:(id)sender
{
    [self.tblView setEditing:!tblView.isEditing animated:YES];
}

#pragma mark - UIAlertView Delegate Methods

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (textField.text && ![textField.text isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (![textField.text isEqualToString:@""]) {
        
        Album *album = [[Album alloc] init];
        album.name = textField.text;
        album.dateAdded = [NSDate date];
        
        [self selectImageForAlbums:album];
    }
}

#pragma - select image for an album

- (void)selectImageForAlbums:(Album *)album
{
    __block MCFolderTableViewController *__self = self;
    
    self.didSelectImagesForAlbumBlock = ^(NSArray *assets){
        
         NSManagedObjectContext *context = [__self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[__self.fetchedResultsController fetchRequest] entity];
        Album_ *nalbum = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        [nalbum setValue:album.name forKey:@"name"];
        [nalbum setValue:album.dateAdded forKey:@"dateAdded"];

        // Save the context.
        [context save:nil];
        
        NSMutableArray *assetURLs = [[NSMutableArray alloc] init];
        for (ALAsset *selectedAsset in assets) {
            Photo_ *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            [newPhoto setRepresentUrl:selectedAsset.defaultRepresentation.url.description];
            [newPhoto setNote:@""];
            [newPhoto setDateSelected:[NSDate date]];
            [assetURLs addObject:newPhoto];
        }
        
        NSSet *assetUrlSet = [NSSet setWithArray:assetURLs];
        [nalbum addPhotosInAlbum:assetUrlSet];
        Photo_ *lastPhoto = [assetURLs lastObject];
        [nalbum setPosterUrl:lastPhoto.representUrl];
        
        [context save:nil];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Debug" message:[NSString stringWithFormat:@"Selected %i images for Album %@", assets.count, album.name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    };
    
    self.pickerController = [[WSAssetPickerController alloc] initWithDelegate:self withAlbumName:album.name];
    [self presentViewController:self.pickerController animated:YES completion:NULL];
}

#pragma mark - WSAssetPickerControllerDelegate Methods

- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (assets.count > 0 && self.didSelectImagesForAlbumBlock) {
            self.didSelectImagesForAlbumBlock(assets);
        }
    }];
}


@end
