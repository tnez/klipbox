////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////


#import <Cocoa/Cocoa.h>
@class TNKlipboxDocument;
@class TNKlipboxBoxView;

@interface TNKlipboxDomainWindowView : NSView {
  IBOutlet TNKlipboxDocument *owner;
  IBOutlet NSWindow *myWindow;
  TNKlipboxBoxView *tempView;
}
@property (assign) IBOutlet TNKlipboxDocument *owner;
@property (assign) IBOutlet NSWindow *myWindow;
@end
