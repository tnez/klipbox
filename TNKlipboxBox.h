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
  TNKlipboxDocument *myDocument;  
  NSView *myView;
  float x;
  float y;
  float w;
  float h;
  NSString *boxID;  
  NSInteger macroPollingInterval;
  NSInteger microPollingInterval;
  NSString *pipeCommand;
}

@property (assign) TNKlipboxDocument *myDocument;
@property (retain) NSView *myView;
@property (retain) NSString *boxID;
@property (readwrite) NSInteger macroPollingInterval;
@property (readwrite) NSInteger microPollingInterval;
@property (retain) NSString *pipeCommand;

- (void)drawUsingView:(NSView **)newView;
- (NSRect)frame;
- (id)initForDocument:(TNKlipboxDocument *)document withRect:(NSRect)rect usingView:(NSView **)view error:(NSError **)outError;
- (void)setFrame:(NSRect)newFrame;
- (void)updateFrame;

#pragma mark NSCodingProtocol
- (id)initWithCoder:(NSCoder *)aCoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

NSString * const TNKlipboxBoxIDKey;
NSString * const TNKlipboxBoxXKey;
NSString * const TNKlipboxBoxYKey;
NSString * const TNKlipboxBoxWidthKey;
NSString * const TNKlipboxBoxHeightKey;
NSString * const TNKlipboxBoxMacroPollingKey;
NSString * const TNKlipboxBoxMicroPollingKey;
NSString * const TNKlipboxBoxPipeCommandKey;


@end

