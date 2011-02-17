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

- (id)initFromSender:(id)sender withRect:(NSRect)rect error:(NSError **)outError
{
  if(self=[super init])
  {
    myDocument = sender;
    [self setMyView:[[TNKlipboxBoxView alloc] initWithFrame:rect]];
    // set new box name / ID
    [self setBoxID:[NSString stringWithFormat:@"New Klipbox %d",[[myDocument klipboxes] count]]];
    // TODO: set default macro and micro polling info
    [self setMacroPollingInterval:500]; // half a second
    [self setMicroPollingInterval:10];  // hundreth of a second
    // TODO: set default pipe command
    [self setPipeCommand:@"> /Users/tnesland/Desktop/ImgOut/%@.jpg"]; // write image out to ~/Desktop/ImgOut/...jpg
  }
  // else.. there was an error initializing box
  if(outError)
  {
    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
  }
  return self;
}

- (void)updateFrame:(NSNotification *)aNote
{
  NSRect theFrame = [myView frame];
  x = theFrame.origin.x;
  y = theFrame.origin.y;
  w = theFrame.size.width;
  h = theFrame.size.height;
}

#pragma mark NSCodingProtocol
- (id)initWithCoder:(NSCoder *)aCoder {
  // TODO: implement initWithCoder
  return nil;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
  // TODO: implement endcodeWithCoder
}

@end





