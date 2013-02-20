//
//  Photo.h
//  MemoCamera
//
//  Created by Peerames on 2/3/13.
//  Copyright (c) 2013 Peerames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, retain) NSString * representUrl;
@property (nonatomic, retain) NSDate * dateSelected;
@property (nonatomic, retain) NSString * note;

@end
