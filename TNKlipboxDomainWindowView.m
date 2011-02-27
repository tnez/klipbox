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
#import "TNKlipboxPasteBoard.h"

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
- (BOOL)isFlipped {
  return YES;
}

#pragma mark Keyboard Handling
- (IBAction)paste:(id)sender {
  // get object from paste board
  id objectToPaste = [[TNKlipboxPasteBoard sharedPasteBoard] objectToPaste];
  // if the object exists and is a klipbox
  if(objectToPaste && [objectToPaste isKindOfClass:[TNKlipboxBox class]]) {
    // get mouse point relative to domain
    NSPoint mouse = [self convertPoint:[NSEvent mouseLocation] toView:self];
    // get size of archbox
    NSSize archSize = [objectToPaste frame].size;
    // make new target frame
    NSRect targetFrame = NSMakeRect(mouse.x,mouse.y,archSize.width,archSize.height);
    // create new box
    [owner makeNewKlipboxWithRect:targetFrame];
    DLog(@"Attempting to paste new box at X:%f Y:%f",mouse.x,mouse.y);
  }
}

#pragma mark Mouse Handling
- (BOOL)acceptsFirstResponder
{
  return YES;
}
- (void)mouseDown: (NSEvent *)theEvent
{
  if([theEvent clickCount]==2) {
    // create a new klipbox
    NSPoint tempOrigin = [theEvent locationInWindow];
    NSRect tempFrame = NSMakeRect(tempOrigin.x,tempOrigin.y,200,100);
    [owner makeNewKlipboxWithRect:tempFrame];
  } else {
    [super mouseDown:theEvent];
  }
}

@end
