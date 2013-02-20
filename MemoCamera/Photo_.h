//
//  Photo_.h
//  MemoCamera
//
//  Created by Peerames on 2/20/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album_;

@interface Photo_ : NSManagedObject

@property (nonatomic, retain) NSDate * dateSelected;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * representUrl;
@property (nonatomic, retain) NSSet *album;
@end

@interface Photo_ (CoreDataGeneratedAccessors)

- (void)addAlbumObject:(Album_ *)value;
- (void)removeAlbumObject:(Album_ *)value;
- (void)addAlbum:(NSSet *)values;
- (void)removeAlbum:(NSSet *)values;

@end
