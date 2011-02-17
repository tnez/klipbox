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
    // Initialization code here.
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

@end
