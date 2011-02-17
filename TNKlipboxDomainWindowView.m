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

#pragma mark Mouse Handling
- (BOOL)acceptsFirstResponder
{
  return YES;
}
- (void)mouseDown: (NSEvent *)theEvent
{
  // make new klipbox box w/ origin at point
  NSPoint tempOrigin = [myWindow mouseLocationOutsideOfEventStream];
  NSRect tempFrame = NSMakeRect(tempOrigin.x,tempOrigin.y,50,50);
  [owner makeNewKlipboxWithRect:tempFrame];
}

@end
