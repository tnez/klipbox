//
//  TNKlipboxDocument.m
//  klipbox
//
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
//

#import "TNKlipboxDocument.h"
#import "TNKlipboxBox.h"

@implementation TNKlipboxDocument

@synthesize klipboxes;

#pragma mark Housekeeping
- (void)dealloc
{
  // remove notifications
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  // release local memory
  [klipboxes release];klipboxes=nil;
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
  [self renderKlipboxes];
}

#pragma mark Accessors
- (NSWindow *)domainWindow
{
  return domainWindow;
}

#pragma mark Document Creation
- (id)initWithType: (NSString *)typeName error: (NSError **)outError
{
  if(self=[super initWithType:typeName error:outError])
  {
    x = 350;
    y = 200;
    w = 650;
    h = 400;
    klipboxes = [[NSMutableArray alloc] initWithCapacity:5];
  }
  return self;
}

#pragma mark Document Editing
- (void)makeNewKlipboxWithRect:(NSRect)aRect
{
  NSError *error = nil;
  NSView *newView;
  // create the new klipbox and add to klipbox array
  TNKlipboxBox *newBox = [[TNKlipboxBox alloc] initForDocument:self withRect:aRect usingView:&newView error:&error];
  if(error)
  {
    ELog(@"%@",[error localizedDescription]);
    return;
  }
  DLog(@"Look at my new box: %@",newBox);
  [klipboxes addObject:newBox]; // add new box to stack
  [[domainWindow contentView] addSubview:newView];
  [newView setNeedsDisplay:YES];
  [[domainWindow contentView] setNeedsDisplay:YES];
}

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

- (void)renderKlipboxes
{
  NSView *newView;
  for(TNKlipboxBox *box in klipboxes)
  {
    [box setMyDocument:self];
    [box drawUsingView:&newView];
    [[domainWindow contentView] addSubview:newView];
  }
  [[domainWindow contentView] setNeedsDisplay:YES];
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

#pragma mark Operations
- (IBAction)start: (id)sender
{
  if(!isRunning)
  {
    DLog(@"Starting %@",[self displayName]);
    [klipboxes makeObjectsPerformSelector:@selector(beginRecording)];
    isRunning = YES;
  }
}

- (IBAction)stop: (id)sender
{
  if(isRunning)
  {
    DLog(@"Stopping %@",[self displayName]);
    [klipboxes makeObjectsPerformSelector:@selector(stopRecording)];
    isRunning = NO;
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
