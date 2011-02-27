////////////////////////////////////////////////////////////////////////////////
//  TNKlipboxPasteBoard.m
//  klipbox
//  ----------------------------------------------------------------------------
//  Author: Travis Nesland <tnesland@gmail.com>
//  Created: 2/27/11
//  Copyright 2011. All rights reserved.
//  ----------------------------------------------------------------------------
//  This is a one-object paste-bin... it simply holds on to
//  one object after it has been copied, so that it can
//  later be pasted. Once an object is added to the paste-bin
//  it lives there for the life of the application or until
//  it is replaced by another object.
////////////////////////////////////////////////////////////////////////////////


#import "TNKlipboxPasteBoard.h"
#import "TNKlipboxBox.h"

@implementation TNKlipboxPasteBoard

@synthesize objectToPaste;

- (void)dealloc {
  [objectToPaste release]; objectToPaste=nil;
  [super dealloc];
}

+ (TNKlipboxPasteBoard *)sharedPasteBoard {
  static TNKlipboxPasteBoard *sharedInstance;
  @synchronized(self) {  
    if(!sharedInstance) {
      sharedInstance = [[TNKlipboxPasteBoard alloc] init];
    }
  }
  return sharedInstance;
}
    
- (BOOL)copyObject:(id)object {
  // if the object does not respond to paste at point,
  // then we won't be able to paste, so don't copy
  if([object isKindOfClass:[TNKlipboxBox class]]) {
    [self setObjectToPaste:object];
    return YES;
  } else {
    [self setObjectToPaste:nil];
    return NO;
  }
}

- (BOOL)cutObject:(id)object {
  // if we can copy this object, do so, then delete
  if([self copyObject:object]) {
    // this is expected - we are safe to delete
    [object delete:self];
    return YES;
  } else {
    // we cannot copy, let's inform the user and
    // ask them if we should go ahead and delete
    [NSApp presentError:@"Cannot copy this object, so Cut operation has been aborted"];
    return NO;
  }
}

@end
