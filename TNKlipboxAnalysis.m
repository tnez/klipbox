////////////////////////////////////////////////////////////////////////////////
//  klipbox
//  ----------------------------------------------------------------------------
//  Created by Travis Nesland on 2/28/11.
//  Copyright 2011. All rights reserved.
////////////////////////////////////////////////////////////////////////////////

#import "TNKlipboxAnalysis.h"
#import "TNKlipboxDocument.h"
#import "TNKlipboxProgressIndicator.h"

@implementation TNKlipboxAnalysis

@synthesize myDocument;
@synthesize results;
@synthesize myReportWindow;
@synthesize myReportView;
@synthesize selection;

#pragma mark Housekeeping
- (void)dealloc {
  DLog(@"... deallocating");
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [results release];results=nil;
  [selection release];selection=nil;
  [super dealloc];
}

- (id)initForDocument: (TNKlipboxDocument *)aDoc {
  if(self=[super init]) {
    // initialize vars
    myDocument = aDoc;
    results = [[NSMutableArray alloc] init];
    selection = [[NSIndexSet alloc] init];
    // load the nib bundle
    [NSBundle loadNibNamed:TNKlipboxAnalysisNibKey owner:self];
    // register for window closing notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:myReportWindow];
    // make report window key
    [myReportWindow makeKeyAndOrderFront:self];
    return self;
  }
  ELog(@"Could not initialize analysis object / nib");
  return nil;
}

#pragma mark Public
- (void)addRecord: (NSMutableDictionary *)aRecord {
  [results addObject:aRecord];
  [myReportView reloadData];
}

- (void)documentDidFinishAnalysis {
  DLog(@"Document did finish analyzing");
  [self sortResults];
  [self groupImages];
  [self colorCodeResults];
  [myReportView reloadData];
  [self setSelection:[myReportView selectedRowIndexes]];
  [myReportView setNeedsDisplay:YES];
}

#pragma mark NSTableViewDataSource Protocol
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  return [results count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
  NSDictionary *rec = (NSDictionary *)[results objectAtIndex:rowIndex];
  return [rec objectForKey:[aTableColumn identifier]];
}

- (void)setSelection:(NSIndexSet *)new {
  if(new!=selection) {
    [selection release];selection=nil;
    selection = [new retain];
    // delete old highlights
    [myDocument highlightKlipbox:nil];
    // highlight all boxes matching selection
    NSUInteger index=[selection firstIndex];
    while(index != NSNotFound) {
      // highlight the box
      TNKlipboxBox *box = [[results objectAtIndex:index] objectForKey:TNKlipboxAnalysisPtrKey];
      [myDocument highlightKlipbox:box];
      // next index
      index=[selection indexGreaterThanIndex: index];
    }
  }
}

#pragma mark @Private
- (void)colorCodeResults {
  DLog(@"Beginning color coding");
  // TODO: implement
}

- (void)groupImages {
  DLog(@"Beginning grouping of images");
  int row = 0;
  int matchRow;
  int nextGroup = 0;
  // for each entry
  for(NSMutableDictionary *rec in results) {
    // if the element has not yet been grouped
    if([[rec valueForKey:TNKlipboxAnalysisImgGroupKey] intValue] == 0) {
      // the element by default gets next group
      nextGroup++;
      [rec setValue:[NSNumber numberWithInt:nextGroup] forKey:TNKlipboxAnalysisImgGroupKey];
      // then look for any possible matches below us
      for(int j=row+1;j<[results count];j++) {
        // if the object hasn't been processed yet
        NSMutableDictionary *twinRec = [results objectAtIndex:j];
        if([[twinRec valueForKey:TNKlipboxAnalysisImgGroupKey] intValue] == 0) {
          // then compare the image data
          if([[twinRec valueForKey:TNKlipboxAnalysisImgDataKey]
              isEqualToData:[rec valueForKey:TNKlipboxAnalysisImgDataKey]]) {
            // then they are twins, set the twin group equal to top group
            [twinRec setValue:[NSNumber numberWithInt:nextGroup] forKey:TNKlipboxAnalysisImgGroupKey];
          }
        }
      } // end of search for twins
    }   // end of this record processing
    // increment ctrs
    row++;
    matchRow = row+1;
  }
}

- (void)sortResults {
  DLog(@"Beginning to sort the results");
  NSSortDescriptor *desc;
  desc = [[NSSortDescriptor alloc] initWithKey:TNKlipboxAnalysisBoxIDKey ascending:YES];
  NSArray *aDesc = [[NSArray alloc] initWithObjects:desc,nil];
  [results sortUsingDescriptors:aDesc];
  [aDesc release];aDesc=nil;
  [desc release];desc=nil;
}

- (void)windowWillClose:(NSNotification *)aNote {
  DLog(@"Window will close notification");
  // de-highlight all klipboxes
  [myDocument highlightKlipbox:nil];
}

#pragma mark Keys
NSString * const TNKlipboxAnalysisBoxIDKey = @"id";
NSString * const TNKlipboxAnalysisLatencyKey = @"latency";
NSString * const TNKlipboxAnalysisImgDataKey = @"data";
NSString * const TNKlipboxAnalysisImgGroupKey = @"group";
NSString * const TNKlipboxAnalysisPtrKey = @"ptr";
NSString * const TNKlipboxAnalysisNibKey = @"TNKlipboxReport";

@end
