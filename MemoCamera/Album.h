//
//  MNAlbum.h
//  MemoCamera
//
//  Created by Peerames on 1/21/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@interface Album : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *dateAdded;
@property (strong, nonatomic) NSString *note;
@property (nonatomic, readwrite) int albumId;
@property (strong, nonatomic) NSString *posterUrl;
@property (nonatomic, retain) Photo *photosInAlbum;

@end
