////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import "TNKlipboxBoxView.h"
#import "TNKlipboxDocument.h"
#import "TNKlipboxBox.h"
#import "TNKlipboxPasteBoard.h"

@implementation TNKlipboxBoxView

@synthesize owner;

- (void)awakeFromNib
{
  [self setFrame:[owner frame]];
  [self setNeedsDisplay:YES];
}

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    selectionMode = 0;
//    [self setFrame:frame];
//    [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  // 1) Invalidate the area around the focus ring
  [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
  // Draw background
  [[NSColor blackColor] set];
  NSRectFill(dirtyRect);
  // 2) Save the graphics state
  [NSGraphicsContext saveGraphicsState];
  // 3) Set the focus ring type
  if ([[self window] firstResponder] == self) {
    // NSSetFocusRingStyle(NSFocusRingAbove);
    // or
    NSSetFocusRingStyle(NSFocusRingBelow);
  }
  // If I do draw background here instead then background gets focus ring as well.
  // 4) Draw a rectangle
  NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSInsetRect([self bounds], 1.0, 1.0)];
  [[NSColor whiteColor] set];
  [path stroke];
  // 5) Restore the graphics state
  [NSGraphicsContext restoreGraphicsState];  
  // set transparency
  [self setAlphaValue:0.4];
}

- (BOOL)isFlipped {
  return NO;
}

#pragma mark Keyboard Events
- (void)keyDown:(NSEvent *)theEvent
{
  if([theEvent modifierFlags] & NSShiftKeyMask)
  {
    NSSize tempSize = [self frame].size;
    switch([theEvent keyCode])
    {
      case 123: // left key
        [self resizeW:(tempSize.width-1.0) H:tempSize.height];
        break;
      case 124: // right key
        [self resizeW:(tempSize.width+1.0) H:tempSize.height];
        break;
      case 125: // down key
        [self resizeW:tempSize.width H:(tempSize.height+1.0)];
        break;
      case 126: // up key
        [self resizeW:tempSize.width H:(tempSize.height-1.0)];
        break;
      default:
        [super keyDown:theEvent];
        return;
    }
    return;
  }
  if([theEvent modifierFlags] & NSNumericPadKeyMask)
  {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    return;
  }
  // normal key events
  switch ([theEvent keyCode]) {
    case 36: // return
      [owner openInfoPanel:self];
      break;
    case 48: // tab
      [[owner myDocument] selectNextKlipboxUsingCurrentKlipbox:owner];  
      break;
    case 51: // delete key
      [self delete:theEvent];
      break;
    case 53: // escape key
      [[[owner myDocument] domainWindow] makeFirstResponder:nil];
      break;
    case 76: // enter key
      [owner openInfoPanel:self];
      break;
    case 117: // backspace key
      [self delete:theEvent];
      break;
    default:
      DLog(@"Key code: %d",[theEvent keyCode]);
      [super keyDown:theEvent];
      break;
  }
}

#pragma mark Mouse Events
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
    //float newY = oldFrame.origin.y + [theEvent deltaY];    
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

#pragma mark Messages
- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (BOOL)becomeFirstResponder
{
  DLog(@"%@ is becoming first responder",[owner boxID]);
  [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
  return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
  DLog(@"%@ is resigning first responder",[owner boxID]);
  [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];  
  return [super resignFirstResponder];
}

#pragma mark Responders
- (IBAction)copy:(id)sender
{
  [[TNKlipboxPasteBoard sharedPasteBoard] copyObject:owner];
}

- (IBAction)copyToTarget:(id)sender
{
}

- (IBAction)cut:(id)sender
{
  [[TNKlipboxPasteBoard sharedPasteBoard] cutObject:owner];
}

- (IBAction)delete:(id)sender
{
  DLog(@"%@ is trying to self destruct!!!",[owner boxID]);
  [[self window] makeFirstResponder:[self superview]];
  [[self superview] setNeedsDisplay:YES];
  [self removeFromSuperview];
  [owner delete:sender];
}

#pragma mark Move
- (IBAction)moveUp:(id)sender
{
  // get new frame
  NSRect myFrame = [self frame];
  [self setFrame:NSMakeRect(myFrame.origin.x,myFrame.origin.y-1.0,myFrame.size.width,myFrame.size.height)];
  [self setNeedsDisplay:YES];
  [owner updateFrame];
}

- (IBAction)moveDown:(id)sender
{
  // get new frame
  NSRect myFrame = [self frame];
  [self setFrame:NSMakeRect(myFrame.origin.x,myFrame.origin.y+1.0,myFrame.size.width,myFrame.size.height)];
  [self setNeedsDisplay:YES];
  [owner updateFrame];
}

- (IBAction)moveLeft:(id)sender
{
  // get new frame
  NSRect myFrame = [self frame];
  [self setFrame:NSMakeRect(myFrame.origin.x-1.0,myFrame.origin.y,myFrame.size.width,myFrame.size.height)];
  [self setNeedsDisplay:YES];
  [owner updateFrame];
}

- (IBAction)moveRight:(id)sender
{
  // get new frame
  NSRect myFrame = [self frame];
  [self setFrame:NSMakeRect(myFrame.origin.x+1.0,myFrame.origin.y,myFrame.size.width,myFrame.size.height)];
  [self setNeedsDisplay:YES];
  [owner updateFrame];
}

#pragma mark Resize
- (void)resizeW:(float)width H:(float)height
{
  NSRect oldFrame = [self frame];
  [self setFrame:NSMakeRect(oldFrame.origin.x,oldFrame.origin.y,width,height)];
  [self setNeedsDisplay:YES];
  [owner updateFrame];
}
@end
