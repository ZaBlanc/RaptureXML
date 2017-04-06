//
//  DeepTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RaptureTestSuite.h"

@interface DeepTests : RaptureTestSuite {
}

@end



@implementation DeepTests

- (void)testQuery {
    RXMLElement *rxml = [self testXML];
    __block NSInteger i;
    
    // count the players
    i = 0;
    
    [rxml iterate:@"players.player" usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
    XCTAssertEqual(i, 9);

    // count the first player's name
    i = 0;
    
    [rxml iterate:@"players.player.name" usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
    XCTAssertEqual(i, 1);

    // count the coaches
    i = 0;
    
    [rxml iterate:@"players.coach" usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
    XCTAssertEqual(i, 1);
}

@end
