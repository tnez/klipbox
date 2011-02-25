////////////////////////////////////////////////////////////
//  TNKlipboxBoxInfoPanel.h
//  klipbox
//  --------------------------------------------------------
//  Author: Travis Nesland <tnesland@gmail.com>
//  Created: 2/25/11
//  Copyright 2011 smoooosh software. All rights reserved.
/////////////////////////////////////////////////////////////
#import <Cocoa/Cocoa.h>

@class TNKlipboxBox;

@interface TNKlipboxBoxInfoPanel : NSPanel {
  TNKlipboxBox *_owner;
  NSTextField *_boxID;  
  NSTextField *_macroPollingInterval;  
  NSTextField *_microPollingInterval;
  NSTextField *_pipeCommand;
}
@property (assign) IBOutlet TNKlipboxBox *_owner;
@property (assign) IBOutlet NSTextField *_boxID;
@property (assign) IBOutlet NSTextField *_macroPollingInterval;
@property (assign) IBOutlet NSTextField *_microPollingInterval;
@property (assign) IBOutlet NSTextField *_pipeCommand;

- (void)commitChanges;
- (void)loadValues;

@end
