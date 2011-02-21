////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//  TodoList:
//  - decide which expansion options to include in pipe command (out inc,
//    box id, etc.)
//  - add switch between write | pipe | append?
////////////////////////////////////////////////////////////////////////////////

#import "TNKlipboxBox.h"
#import "TNKlipboxDocument.h"
#import "TNKlipboxBoxView.h"

@implementation TNKlipboxBox

@synthesize boxID;
@synthesize myView;
@synthesize myDocument;
@synthesize macroPollingInterval;
@synthesize microPollingInterval;
@synthesize pipeCommand;

- (void)dealloc
{
  [boxID release];boxID=nil;
  [myView release];myView=nil;
  [pipeCommand release];pipeCommand=nil;
  // ----------------------------------
  [super dealloc];
}

- (NSRect)absFrame
{
  // offset of document window
  NSPoint offset = [[myDocument domainWindow] convertBaseToScreen:NSMakePoint(0,0)];
  // add offset to view's origin
  NSPoint absOrigin = NSMakePoint(x+offset.x,y+offset.y);
  return NSMakeRect(absOrigin.x,absOrigin.y,w,h);
}
  
- (void)drawUsingView:(NSView **)newView
{
  if(!newView)
  {
    ELog(@"No view pointer provided");
    return;
  }
  [self setMyView:[[TNKlipboxBoxView alloc] initWithFrame:[self frame]]];
  [myView setOwner:self];
  *newView = myView;
  [myView setNeedsDisplay:YES];
}

- (NSRect)frame
{
  return NSMakeRect(x,y,w,h);
}

- (id)initForDocument:(TNKlipboxDocument *)document withRect:(NSRect)rect usingView:(NSView **)view error:(NSError **)outError
{
  if(self=[super init])
  {
    myDocument = document;
    // set new box name / ID
    [self setBoxID:[NSString stringWithFormat:@"New Klipbox %d",[[myDocument klipboxes] count]]];
    [self setFrame:rect];
    // TODO: set default macro and micro polling info
    [self setMacroPollingInterval:500]; // half a second
    [self setMicroPollingInterval:10];  // hundreth of a second
    // TODO: set default pipe command
    [self setPipeCommand:@"> /Users/tnesland/Desktop/ImgOut/%@.jpg"]; // write image out to ~/Desktop/ImgOut/...jpg
    // draw view
    [self drawUsingView:view];
  }
  // else.. there was an error initializing box
  if(!self && outError)
  {
    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
  }
  return self;
}

- (void)setFrame:(NSRect)newFrame
{
  x = newFrame.origin.x;
  y = newFrame.origin.y;
  w = newFrame.size.width;
  h = newFrame.size.height;
}

- (void)updateFrame
{
  NSRect theFrame = [myView frame];
  x = theFrame.origin.x;
  y = theFrame.origin.y;
  w = theFrame.size.width;
  h = theFrame.size.height;
}

#pragma mark Run Operations
- (void)beginRecording
{
  @synchronized(self)
  {
    shouldContinueRecording = YES;
    outsideTimer = [NSTimer scheduledTimerWithTimeInterval:macroPollingInterval/1000 target:self selector:@selector(initiateSnapshot:) userInfo:nil repeats:YES];
    DLog(@"%@ will begin recording",boxID);
  }
}

- (void)initiateSnapshot: (NSTimer *)theTimer
{
  if(shouldContinueRecording)
  {
    DLog(@"%@ is trying to take a snapshot",boxID);
    [self performSelectorInBackground:@selector(takeSnapshot) withObject:nil];
  }
}

- (void)stopRecording
{
  @synchronized(self)
  {
    shouldContinueRecording = NO;
    [outsideTimer invalidate];
    DLog(@"%@ will stop recording",boxID);
  }
}

- (void)takeSnapshot
{
  // this message is invoked on background threads...
  // so it needs its own autorelease pool
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  // TODO: add image to our processing queue
  // ...for testing we will write out the image for human inspection
  // ...
  // get image reference
  CGImageRef snapshot = CGWindowListCreateImage(NSRectToCGRect([self absFrame]),kCGWindowListOptionOnScreenBelowWindow,[[myDocument domainWindow] windowNumber],kCGWindowImageBoundsIgnoreFraming);  
  // setup image destination
  NSBitmapImageRep *bm = [[NSBitmapImageRep alloc] initWithCGImage:snapshot];
  NSData *oData = [bm representationUsingType:NSTIFFFileType properties:nil];
  [oData writeToFile:[NSString stringWithFormat:@"/Users/tnesland/Desktop/OUT/%@_%d.tiff",boxID,[NSDate date]] atomically:YES];
  [bm release];
  DLog(@"%@ did finish taking snapshot",boxID);
  [pool release];
}  
  
#pragma mark NSCodingProtocol
- (id)initWithCoder:(NSCoder *)aCoder {
  if(self=[super init])
  {
    [self setBoxID:[aCoder decodeObjectForKey:TNKlipboxBoxIDKey]];
    x = [aCoder decodeFloatForKey:TNKlipboxBoxXKey];
    y = [aCoder decodeFloatForKey:TNKlipboxBoxYKey];
    w = [aCoder decodeFloatForKey:TNKlipboxBoxWidthKey];
    h = [aCoder decodeFloatForKey:TNKlipboxBoxHeightKey];
    macroPollingInterval = [aCoder decodeIntegerForKey:TNKlipboxBoxMacroPollingKey];
    microPollingInterval = [aCoder decodeIntegerForKey:TNKlipboxBoxMicroPollingKey];
    [self setPipeCommand:[aCoder decodeObjectForKey:TNKlipboxBoxPipeCommandKey]];
    
  }
  DLog(@"Decoded Klipbox: %@",boxID);
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  DLog(@"Attempint to endcode klipbox: %@",boxID);
  [aCoder encodeObject:boxID forKey:TNKlipboxBoxIDKey];
  [aCoder encodeFloat:[myView frame].origin.x forKey:TNKlipboxBoxXKey];
  [aCoder encodeFloat:[myView frame].origin.y forKey:TNKlipboxBoxYKey];
  [aCoder encodeFloat:[myView frame].size.width forKey:TNKlipboxBoxWidthKey];
  [aCoder encodeFloat:[myView frame].size.height forKey:TNKlipboxBoxHeightKey];
  [aCoder encodeInteger:macroPollingInterval forKey:TNKlipboxBoxMacroPollingKey];
  [aCoder encodeInteger:microPollingInterval forKey:TNKlipboxBoxMicroPollingKey];
  [aCoder encodeObject:pipeCommand forKey:TNKlipboxBoxPipeCommandKey];
}

NSString * const TNKlipboxBoxIDKey = @"TNKlipboxBoxID";
NSString * const TNKlipboxBoxXKey = @"TNKlipboxBoxX";
NSString * const TNKlipboxBoxYKey = @"TNKlipboxBoxY";
NSString * const TNKlipboxBoxWidthKey = @"TNKlipboxBoxWidth";
NSString * const TNKlipboxBoxHeightKey = @"TNKlipboxBoxHeight";
NSString * const TNKlipboxBoxMacroPollingKey = @"TNKlipboxBoxMacroPolling";
NSString * const TNKlipboxBoxMicroPollingKey = @"TNKlipboxBoxMicroPolling";
NSString * const TNKlipboxBoxPipeCommandKey = @"TNKlipboxBoxPipeCommand";



@end





