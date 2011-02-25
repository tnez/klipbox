////////////////////////////////////////////////////////////
//  TNKlipboxBoxInfoPanel.m
//  klipbox
//  --------------------------------------------------------
//  Author: Travis Nesland <tnesland@gmail.com>
//  Created: 2/25/11
//  Copyright 2011 smoooosh software. All rights reserved.
/////////////////////////////////////////////////////////////
#import "TNKlipboxBoxInfoPanel.h"
#import "TNKlipboxBox.h"

@implementation TNKlipboxBoxInfoPanel

@synthesize _owner;
@synthesize _boxID;
@synthesize _macroPollingInterval;
@synthesize _microPollingInterval;
@synthesize _pipeCommand;

/*
 User is done editing klipbox info and has either selected
 to commit or discard the changes
 */

- (IBAction)performClose:(id)sender
{
  DLog(@"Perform close has been called on panel with tag: %d",[sender tag]);
  if([sender tag])
  {
    [self commitChanges];
  }
  [NSApp abortModal];
  DLog(@"Modal has been aborted");
  [super performClose:sender];
}

- (void)commitChanges
{
  DLog(@"Committing values");
  [_owner setBoxID:[_boxID stringValue]];
  [_owner setMacroPollingInterval:[[_macroPollingInterval stringValue] integerValue]];
  [_owner setMicroPollingInterval:[[_microPollingInterval stringValue] integerValue]];
  [_owner setPipeCommand:[_pipeCommand stringValue]];

}

- (void)loadValues
{
  DLog(@"Loading values");  
  [_boxID setStringValue:[_owner boxID]];
  [_macroPollingInterval setStringValue:[NSString stringWithFormat:@"%d",[_owner macroPollingInterval]]];
  [_microPollingInterval setStringValue:[NSString stringWithFormat:@"%d",[_owner microPollingInterval]]];
  [_pipeCommand setStringValue:[_owner pipeCommand]];
}
  
@end
