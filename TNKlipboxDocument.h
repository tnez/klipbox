////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/14/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>

@interface TNKlipboxDocument : NSDocument
{
  float x;                           // x of origin
  float y;                           // y of origin
  float w;                           // w of rect
  float h;                           // h of rect
  NSMutableArray *klipboxes;           // array of klipboxes in the given document
  NSString *fileURL;                   // URL of file (used to save)
  IBOutlet NSWindow *domainWindow;
}

- (void)getInfoFromPlist: (NSDictionary *)aPlist error:(NSError **)error;
- (NSRect)frame;
- (CGFloat)transparency;

#pragma mark Key Values
NSString * const TNKlipboxDocumentTypeKey;
NSString * const TNKlipboxDocumentNameKey;
NSString * const TNKlipboxDocumentOriginXKey;
NSString * const TNKlipboxDocumentOriginYKey;
NSString * const TNKlipboxDocumentRectangleWidthKey;
NSString * const TNKlipboxDocumentRectangleHeightKey;
NSString * const TNKlipboxDocumentKlipboxesKey;

#pragma mark Temporary Preference Keys
CGFloat const transparency;
@end



