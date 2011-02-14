//
//  TNKlipboxDocument.h
//  klipbox
//
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface TNKlipboxDocument : NSDocument
{
  NSPoint origin;             // origin to use when document is run
  NSRect bounds;              // bounds to use when document is run
  int frequency;              // frequency with which to take images when run
  int quality;                // quality of images to use when run
  NSMutableArray *klipboxes;  // array of klipboxes in the given document
}
@property(protected) NSPoint origin;
@property(protected) NSRect bounds;
@property(protected) int frequency;
@property(protected) int quality;

@end
