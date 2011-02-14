//
//  TNKlipboxDocument.m
//  klipbox
//
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
//

#import "TNKlipboxDocument.h"

@implementation TNKlipboxDocument

- (void)dealloc
{
  // release any reserved memory
  [klipboxes release];klipboxes=nil;
  // super...
  [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
  return @"TNKlipboxDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
  [super windowControllerDidLoadNib:aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
  [[aController window] setFrame:[self frame] display:YES];
  [[aController window] setAlphaValue:[self transparency]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  @try {
    // attempt to archive our dictionary
    if([typeName isEqualToString:TNKlipboxDocumentTypeKey]) {
      // create a temporary dictionary
      NSDictionary *temp = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:x],
                            TNKlipboxDocumentOriginXKey,
                            [NSNumber numberWithFloat:y],
                            TNKlipboxDocumentOriginYKey,
                            [NSNumber numberWithFloat:w],
                            TNKlipboxDocumentRectangleWidthKey,
                            [NSNumber numberWithFloat:h],
                            TNKlipboxDocumentRectangleHeightKey,
                            nil];
      // create archived version of plist
      NSData *theData = [NSArchiver archivedDataWithRootObject:temp];
      return theData;
    }
  }
  @catch (NSException * e) {
    ELog(@"Error preparing data for archiving: %@",e);
  }
  if ( outError != NULL ) {
    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    return nil;
  }
  return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  // create a dictionary out of the file
  if([typeName isEqualToString:TNKlipboxDocumentTypeKey])
  {
    NSDictionary *myPlist = [NSUnarchiver unarchiveObjectWithData:data];
    [self getInfoFromPlist:myPlist error:outError];
  }
  if ( outError != NULL ) {
    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
  return YES;
}

#pragma mark Custom Functions
/**
 Extract data from plist... record error if any
 */
- (void)getInfoFromPlist:(NSDictionary *)aPlist error:(NSError **)error
{
  // set geometry values
  x = [[aPlist valueForKey:TNKlipboxDocumentOriginXKey] floatValue];
  y = [[aPlist valueForKey:TNKlipboxDocumentOriginYKey] floatValue];
  w = [[aPlist valueForKey:TNKlipboxDocumentRectangleWidthKey] floatValue];  
  h = [[aPlist valueForKey:TNKlipboxDocumentRectangleHeightKey] floatValue];
  // grab klipbox array
  klipboxes = [[NSMutableArray arrayWithArray:[aPlist valueForKey:TNKlipboxDocumentKlipboxesKey]] retain];
}
/** 
 Needs to return are target frame... this may be dynamic in the future
 */
- (NSRect)frame
{
  return NSMakeRect(x,y,w,h);
}

- (float)transparency
{
  return transparency;
}

#pragma mark Key Values
NSString * const TNKlipboxDocumentTypeKey = @"TNKlipboxDocument";
NSString * const TNKlipboxDocumentNameKey = @"TNKlipboxDocumentName";
NSString * const TNKlipboxDocumentOriginXKey = @"TNKlipboxDocumentOriginX";
NSString * const TNKlipboxDocumentOriginYKey = @"TNKlipboxDocumentOriginY";
NSString * const TNKlipboxDocumentRectangleWidthKey = @"TNKlipboxDocumentRectangleWidth";
NSString * const TNKlipboxDocumentRectangleHeightKey = @"TNKlipboxDocumentRectangleHeight";
NSString * const TNKlipboxDocumentKlipboxesKey = @"TNKlipboxDocumentKlipboxes";

#pragma mark Temporary Preference Keys
float const transparency = 0.5;

@end
