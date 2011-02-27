////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
@class TNKlipboxBox;

@interface TNKlipboxDocument : NSDocument
{
  float x;                           // x of origin
  float y;                           // y of origin
  float w;                           // w of rect
  float h;                           // h of rect
  NSMutableArray *klipboxes;         // array of klipboxes in the given document
  NSString *fileURL;                 // URL of file (used to save)
  IBOutlet NSWindow *domainWindow;   // main document window
  NSMutableArray *saveBox;           // box to put every object which we want to save
  BOOL isRunning;
}
@property (readonly) NSMutableArray *klipboxes;

#pragma mark Accessors
- (NSWindow *)domainWindow;

#pragma mark Document Creation
- (id)initWithType: (NSString *)typeName error: (NSError **)outError;

#pragma mark Document Editing
- (void)makeNewKlipboxWithRect:(NSRect)aRect;
- (void)recordNewWindowSize: (NSNotification *)aNote;
- (void)selectNextKlipboxUsingCurrentKlipbox:(TNKlipboxBox *)currentBox;

#pragma mark Document Reading
- (void)decodeWithCoder: (NSCoder *)aCoder;
- (BOOL)readFromData: (NSData*)data ofType:(NSString *)typeName error:(NSError **)outError;
- (void)renderKlipboxes;

#pragma mark Document Writing
- (NSData *)dataOfType: (NSString *)typeName error:(NSError **)outError;
- (void)encodeWithCoder: (NSCoder *)aCoder;

#pragma mark Operations
- (IBAction)start: (id)sender;
- (IBAction)stop: (id)sender;

#pragma mark Preferences
- (NSRect)frame;
- (float)transparency;

#pragma mark Key Values
NSString * const TNKlipboxDocumentTypeKey;
NSString * const TNKlipboxDocumentNameKey;
NSString * const TNKlipboxDocumentOriginXKey;
NSString * const TNKlipboxDocumentOriginYKey;
NSString * const TNKlipboxDocumentRectangleWidthKey;
NSString * const TNKlipboxDocumentRectangleHeightKey;
NSString * const TNKlipboxDocumentKlipboxesKey;

#pragma mark Temporary Preference Keys
float const transparency;
@end



