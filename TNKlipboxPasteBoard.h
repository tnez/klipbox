////////////////////////////////////////////////////////////////////////////////
//  TNKlipboxPasteBoard.h
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

#import <Cocoa/Cocoa.h>

@interface TNKlipboxPasteBoard : NSObject {
  id objectToPaste;
}
@property (retain) id objectToPaste;
+ (TNKlipboxPasteBoard *)sharedPasteBoard;
- (BOOL)copyObject:(id)object;
- (BOOL)cutObject:(id)object;
@end
