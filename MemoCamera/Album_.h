//
//  Album_.h
//  MemoCamera
//
//  Created by Peerames on 2/20/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo_;

@interface Album_ : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * posterUrl;
@property (nonatomic, retain) NSSet *photosInAlbum;
@end

@interface Album_ (CoreDataGeneratedAccessors)

- (void)addPhotosInAlbumObject:(Photo_ *)value;
- (void)removePhotosInAlbumObject:(Photo_ *)value;
- (void)addPhotosInAlbum:(NSSet *)values;
- (void)removePhotosInAlbum:(NSSet *)values;

@end
