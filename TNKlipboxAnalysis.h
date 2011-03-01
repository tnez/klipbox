////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/28/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
@class TNKlipboxDocument;
@class TNKlipboxProgressIndicator;

@interface TNKlipboxAnalysis : NSObject {
  TNKlipboxDocument *myDocument;
  NSMutableArray *results;
  NSWindow *myReportWindow;
  NSTableView *myReportView;
  NSIndexSet *selection;
}
@property (assign) TNKlipboxDocument *myDocument;
@property (retain) IBOutlet NSMutableArray *results;
@property (assign) IBOutlet NSWindow *myReportWindow;
@property (assign) IBOutlet NSTableView *myReportView;
@property (retain) IBOutlet NSIndexSet *selection;

- (void)addRecord: (NSMutableDictionary *)aRecord;
- (void)documentDidFinishAnalysis;
- (id)initForDocument: (TNKlipboxDocument *)aDoc;

#pragma mark NSTableViewDataSource Protocol
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

#pragma mark @Private
- (void)colorCodeResults;
- (void)groupImages;
- (void)sortResults;

#pragma mark Keys
NSString * const TNKlipboxAnalysisBoxIDKey;
NSString * const TNKlipboxAnalysisLatencyKey;
NSString * const TNKlipboxAnalysisImgDataKey;
NSString * const TNKlipboxAnalysisImgGroupKey;
NSString * const TNKlipboxAnalysisPtrKey;
NSString * const TNKlipboxAnalysisNibKey;

@end
