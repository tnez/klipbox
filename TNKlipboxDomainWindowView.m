////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import "TNKlipboxDomainWindowView.h"
#import "TNKlipboxDocument.h"
#import "TNKlipboxBox.h"

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

#pragma mark Mouse Handling
- (BOOL)acceptsFirstResponder
{
  return YES;
}
- (void)mouseDown: (NSEvent *)theEvent
{
  // grab the origin for the new klipbox
  newKlipboxOrigin = [myWindow mouseLocationOutsideOfEventStream];
}

- (void)mouseDragged: (NSEvent *)theEvent
{
  // update the dimensions of the new klipbox
  newKlipboxSize = NSMakeSize( newKlipboxOrigin.x + [theEvent deltaX], newKlipboxOrigin.y + [theEvent deltaY] );
}

- (void)mouseUp: (NSEvent *)theEvent
{
  // initialize the new klipbox using the derived frame
  NSRect newKlipboxRect = NSMakeRect(newKlipboxOrigin.x,newKlipboxOrigin.y,newKlipboxSize.width,newKlipboxSize.height);
  [owner makeNewKlipboxWithRect:newKlipboxRect];
}

@end
