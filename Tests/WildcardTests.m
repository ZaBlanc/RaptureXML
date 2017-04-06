//
//  WildcardTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RaptureTestSuite.h"

@interface WildcardTests : RaptureTestSuite {
}

@end

@implementation WildcardTests

- (void)testEndingWildcard {
    RXMLElement *rxml = [self testXML];
    __block NSInteger i;
    
    // count the players and coaches
    i = 0;

    [rxml iterate:@"players.*" usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
    XCTAssertEqual(i, 10);
}

- (void)testMidstreamWildcard {
    RXMLElement *rxml = [self testXML];
    __block NSInteger i;
    
    // count the tags that have a name
    i = 0;
    
    [rxml iterate:@"players.*.name" usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
  //  XCTAssertEqual(i, 10);

    // count the tags that have a position
    i = 0;
    
    [rxml iterate:@"players.*.position" usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
   // XCTAssertEqual(i, 9);
}

@end
