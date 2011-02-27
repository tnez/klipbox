////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import "TNKlipboxDomainWindowView.h"
#import "TNKlipboxDocument.h"
#import "TNKlipboxBox.h"
#import "TNKlipboxBoxView.h"

@implementation TNKlipboxDomainWindowView

@synthesize owner;
@synthesize myWindow;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

#pragma mark Geometry
- (BOOL)isFlipped
{
  return YES;
}

#pragma mark Mouse Handling
- (BOOL)acceptsFirstResponder
{
  return YES;
}
- (void)mouseDown: (NSEvent *)theEvent
{
  // make new klipbox box w/ origin at point
  NSPoint tempOrigin = [theEvent locationInWindow];
  NSSize mySize = [self frame].size;
  NSRect tempFrame = NSMakeRect(tempOrigin.x,mySize.height-tempOrigin.y,50,50);
  NSView *newView = [owner makeNewKlipboxWithRect:tempFrame];
  [self addSubview:newView];
  [self setNeedsDisplay:YES];
}

@end
