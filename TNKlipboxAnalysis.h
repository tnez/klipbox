////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/28/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
@class TNKlipboxProgressIndicator;

@interface TNKlipboxAnalysis : NSObject {
  NSMutableArray *results;
  NSTableView *myReportView;
}
@property (retain) IBOutlet NSMutableArray *results;
@property (assign) IBOutlet NSTableView *myReportView;

- (void)addRecord: (NSMutableDictionary *)aRecord;
- (void)documentDidFinishAnalysis;

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
NSString * const TNKlipboxAnalysisNibKey;

@end
