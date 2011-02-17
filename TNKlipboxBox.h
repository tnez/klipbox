////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
@class TNKlipboxDocument;
@class TNKlipboxBoxView;

@interface TNKlipboxBox : NSObject <NSCoding>
{
  NSString *boxID;
  NSView *myView;
  TNKlipboxDocument *myDocument;
  float x;
  float y;
  float w;
  float h;
  NSInteger macroPollingInterval;
  NSInteger microPollingInterval;
  NSString *pipeCommand;
}
@property (retain) NSString *boxID;
@property (retain) NSView *myView;
@property (assign) TNKlipboxDocument *myDocument;
@property (readwrite) NSInteger macroPollingInterval;
@property (readwrite) NSInteger microPollingInterval;
@property (retain) NSString *pipeCommand;

- (id)initFromSender:(id)sender withRect:(NSRect)rect error:(NSError **)outError;
- (void)updateFrame:(NSNotification *)aNote;

#pragma mark NSCodingProtocol
- (id)initWithCoder:(NSCoder *)aCoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end

