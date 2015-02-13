//
//  DeepChildrenTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RXMLElement.h"

@interface DeepChildrenTests : XCTestCase {
}

@end



@implementation DeepChildrenTests

- (void)testQuery {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    __block NSInteger i = 0;
    
    // count the players
    RXMLElement *players = [rxml child:@"players"];
    NSArray *children = [players children:@"player"];
    
    [rxml iterateElements:children usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
    XCTAssertEqual(i, 9);
}

- (void)testDeepChildQuery {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    
    // count the players
    RXMLElement *coachingYears = [rxml child:@"players.coach.experience.years"];
    
    XCTAssertEqual(coachingYears.textAsInt, 1);
}

- (void)testDeepChildQueryWithWildcard {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    
    // count the players
    RXMLElement *coachingYears = [rxml child:@"players.coach.experience.teams.*"];
    
    // first team returned
    XCTAssertEqual(coachingYears.textAsInt, 53);
}

@end
