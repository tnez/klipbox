//
//  TNKlipboxDocument.m
//  klipbox
//
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
//

#import "TNKlipboxDocument.h"

@implementation TNKlipboxDocument

#pragma mark Housekeeping
- (void)dealloc
{
  // remove notifications
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  // release any reserved memory
  // [klipboxes release];klipboxes=nil;
  // super...
  [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
      // any global initialization???
    }
    return self;
}

#pragma mark NSDocument Subclassing
- (NSString *)windowNibName
{
  return @"TNKlipboxDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
  [super windowControllerDidLoadNib:aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
  domainWindow = [aController window];
  DLog(@"I am going to set the frame (x:%f,y:%f,w:%f,h:%f)",x,y,w,h);
  [domainWindow setFrame:[self frame] display:YES];
  [domainWindow setAlphaValue:[self transparency]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordNewWindowSize:) name:NSWindowDidResizeNotification object:domainWindow];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordNewWindowSize:) name:NSWindowDidMoveNotification object:domainWindow];
}

#pragma mark Document Creation
- (id)initWithType: (NSString *)typeName error: (NSError **)outError
{
  if(self=[super initWithType:typeName error:outError])
  {
    x = 500;
    y = 500;
    w = 650;
    h = 400;
    klipboxes = [[NSMutableArray alloc] initWithCapacity:5];
  }
  return self;
}

#pragma mark Document Editing
- (void)recordNewWindowSize: (NSNotification *)aNote
{
  DLog(@"Old Dimensions -- x:%f y:%f w:%f h:%f",x,y,w,h);
  NSRect rect = [domainWindow frame];
  x = rect.origin.x;
  y = rect.origin.y;
  w = rect.size.width;
  h = rect.size.height;
  DLog(@"New Dimensions -- x:%f y:%f w:%f h:%f",x,y,w,h);  
}

#pragma mark Document Reading
- (void)decodeWithCoder: (NSCoder *)aCoder
{
  DLog(@"My Coder: %@",aCoder);
  x = [aCoder decodeFloatForKey:TNKlipboxDocumentOriginXKey];
  y = [aCoder decodeFloatForKey:TNKlipboxDocumentOriginYKey];
  w = [aCoder decodeFloatForKey:TNKlipboxDocumentRectangleWidthKey];
  h = [aCoder decodeFloatForKey:TNKlipboxDocumentRectangleHeightKey];
  klipboxes = [aCoder decodeObjectForKey:TNKlipboxDocumentKlipboxesKey];
}

- (BOOL)readFromData: (NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  DLog(@"Type: %@ Data: %@",typeName,data);
  BOOL didRead = YES; // TODO: error checking
  // create a dictionary out of the file
  if([typeName isEqualToString:TNKlipboxDocumentTypeKey])
  {
    [self decodeWithCoder:[[NSKeyedUnarchiver alloc] initForReadingWithData:data]];
  }
  if ( !didRead && outError ) {
    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
  DLog(@"My Data: %@",self);
  return YES;
}

#pragma mark Document Writing
- (NSData *)dataOfType: (NSString *)typeName error:(NSError **)outError
{
  NSData *outData = nil;
  DLog(@"Request for data out of type: %@",typeName);
  // attempt to archive our dictionary
  if([typeName isEqualToString:TNKlipboxDocumentTypeKey]) {
    NSMutableData *myData = [NSMutableData data];
    NSKeyedArchiver *myArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:myData];
    [self encodeWithCoder:myArchiver];
    [myArchiver finishEncoding];
    outData = [NSData dataWithData:myData];
  }
  if ( !outData && outError ) {
    *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    return nil;
  }
  return outData;
}

- (void)encodeWithCoder: (NSCoder *)aCoder
{
  DLog(@"Attempting to encode");
  @try
  {
    [aCoder encodeFloat:x forKey:TNKlipboxDocumentOriginXKey];
    [aCoder encodeFloat:y forKey:TNKlipboxDocumentOriginYKey];
    [aCoder encodeFloat:w forKey:TNKlipboxDocumentRectangleWidthKey];
    [aCoder encodeFloat:h forKey:TNKlipboxDocumentRectangleHeightKey];
    [aCoder encodeObject:klipboxes forKey:TNKlipboxDocumentKlipboxesKey];
  }
  @catch (NSException * e)
  {
    ELog(@"%@",e);
  }
}

#pragma mark Preferences

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
float const transparency = 0.75;

@end