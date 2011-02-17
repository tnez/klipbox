////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import "TNKlipboxBoxView.h"
#import "TNKlipboxBox.h"

@implementation TNKlipboxBoxView

@synthesize owner;

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    selectionMode = 0;
  }
  return self;
}

- (void)drawRect:(NSRect)rect
{
  // fill color w/ white
  [[NSColor blackColor] set];
  [NSBezierPath fillRect:rect];
  // set transparency
  [self setAlphaValue:0.4];
}

#pragma mark Mouse Events

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (void)mouseDown: (NSEvent *)theEvent
{
  if([theEvent clickCount] == 2) // if this is a double-click
  {
    DLog(@"Doulbe-click has occured!!!");
    return;
  }
  selectionMode = TNKlipboxBoxEditModeMove;
}

- (void)mouseDragged: (NSEvent *)theEvent
{
  if(selectionMode==TNKlipboxBoxEditModeMove)
  {
    NSRect oldFrame = [self frame];
    float newX = oldFrame.origin.x + [theEvent deltaX];
    float newY = oldFrame.origin.y - [theEvent deltaY];
    [self setFrame:NSMakeRect(newX,newY,oldFrame.size.width,oldFrame.size.height)];
  }
}

- (void)mouseUp: (NSEvent *)theEvent
{
  switch (selectionMode) {
    case TNKlipboxBoxEditModeMove:
      [owner updateFrame];
      break;
    default:
      break;
  }
}
  


@end
