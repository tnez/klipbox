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
  TNKlipboxBox *owner;
}
@property (assign) TNKlipboxBox *owner;
@end
