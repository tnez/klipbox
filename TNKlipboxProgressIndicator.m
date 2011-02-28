////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/28/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////


#import "TNKlipboxProgressIndicator.h"


@implementation TNKlipboxProgressIndicator

- (void)awakeFromNib {
  [self startAnimation:self];
}

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

@end
