////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
@class TNKlipboxBox;

@interface TNKlipboxBoxView : NSView
{
  IBOutlet TNKlipboxBox *owner;
  NSUInteger selectionMode;
}
@property (assign) IBOutlet TNKlipboxBox *owner;

#pragma mark Responders
- (IBAction)copy:(id)sender;
- (IBAction)copyToTarget:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)delete:(id)sender;

enum TNKlipboxBoxEditMode {
  TNKlipboxBoxEditModeInactive = 0,
  TNKlipboxBoxEditModeResize = 1,
  TNKlipboxBoxEditModeMove = 2,
  TNKlipboxBoxEditModeFocus = 3
}; typedef NSInteger TNKlipboxBoxEditMode;

@end
