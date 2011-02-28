////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
#import <time.h>
@class TNKlipboxDocument;
@class TNKlipboxBoxView;
@class TNKlipboxBoxInfoPanel;

@interface TNKlipboxBox : NSObject <NSCoding>
{
  TNKlipboxDocument *myDocument;  
  IBOutlet TNKlipboxBoxView *myView;
  IBOutlet TNKlipboxBoxInfoPanel *myInfoPanel;
  float x;
  float y;
  float w;
  float h;
  NSString *boxID;  
  NSInteger macroPollingInterval;
  NSInteger microPollingInterval;
  NSString *pipeCommand;
  BOOL shouldContinueRecording;
  NSTimer *outsideTimer;
  NSTimer *insideTimer;
  NSData *lastImage;
  BOOL guard;
}

@property (assign) TNKlipboxDocument *myDocument;
@property (assign) IBOutlet TNKlipboxBoxView *myView;
@property (assign) IBOutlet TNKlipboxBoxInfoPanel *myInfoPanel;
@property (retain) NSString *boxID;
@property (readwrite) NSInteger macroPollingInterval;
@property (readwrite) NSInteger microPollingInterval;
@property (retain) NSString *pipeCommand;
@property (retain) NSData *lastImage;
@property (readwrite) BOOL guard;

- (NSRect)absFrame;
- (void)drawUsingView:(NSView **)newView;
- (NSRect)frame;
- (id)initForDocument:(TNKlipboxDocument *)document withRect:(NSRect)rect usingView:(NSView **)view error:(NSError **)outError;
- (void)setFrame:(NSRect)newFrame;
- (void)updateFrame;

#pragma mark Edit Operations
- (IBAction)delete:(id)sender;
- (IBAction)openInfoPanel:(id)sender;

#pragma mark Run Operations
- (void)beginRecording;
- (NSData *)screenshotAsData;
- (void)stopRecording;
- (void)takeSnapshot;

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

