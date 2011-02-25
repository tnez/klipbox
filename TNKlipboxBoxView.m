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
    [self setFocusRingType:[NSView defaultFocusRingType]];
    [self setKeyboardFocusRingNeedsDisplayInRect:frame];
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
    DLog(@"Double Click!");
    [owner openInfoPanel:self];
    return;
  }
  if([theEvent modifierFlags] & NSShiftKeyMask)
  {
    selectionMode = TNKlipboxBoxEditModeResize;
    DLog(@"Entering resize mode");
    return;
  }
  selectionMode = TNKlipboxBoxEditModeMove;
  DLog(@"Entering move mode");
}

- (void)mouseDragged: (NSEvent *)theEvent
{
  if(selectionMode==TNKlipboxBoxEditModeMove)
  {
    NSRect oldFrame = [self frame];
    float newX = oldFrame.origin.x + [theEvent deltaX];
    float newY = oldFrame.origin.y + [theEvent deltaY];
    [self setFrame:NSMakeRect(newX,newY,oldFrame.size.width,oldFrame.size.height)];
    [self setKeyboardFocusRingNeedsDisplayInRect:[self frame]];
  }
  if(selectionMode==TNKlipboxBoxEditModeResize)
  {
    NSRect oldFrame = [self frame];
    // float newY = oldFrame.origin.y + [theEvent deltaY];    
    float newW = oldFrame.size.width + [theEvent deltaX];
    float newH = oldFrame.size.height + [theEvent deltaY];
    [self setFrame:NSMakeRect(oldFrame.origin.x, oldFrame.origin.y, newW, newH)];
    [self setKeyboardFocusRingNeedsDisplayInRect:[self frame]];
  }
}

- (void)mouseUp: (NSEvent *)theEvent
{
  switch (selectionMode) {
    default:
      [owner updateFrame];
      break;
  }
  selectionMode = 0;
  // give the box focus
}

#pragma mark Responders
- (IBAction)copy:(id)sender
{
}

- (IBAction)copyToTarget:(id)sender
{
}

- (IBAction)cut:(id)sender;
{
}

- (IBAction)delete:(id)sender;
{
}

@end
