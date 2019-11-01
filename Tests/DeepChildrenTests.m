//
//  DeepChildrenTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RXMLElement.h"

@interface DeepChildrenTests : SenTestCase {
}

@end



@implementation DeepChildrenTests

- (void)testQuery {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    __block NSInteger i = 0;
    
    // count the players
    RXMLElement *players = [rxml childElementWithTag:@"players"];
    NSArray *children = [players childrenArrayWithTag:@"player"];
    
    [rxml iterateElements:children usingBlock: ^(RXMLElement *e) {
        i++;
    }];    
    
    STAssertEquals(i, 9, nil);
}

- (void)testDeepChildQuery {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    
    // count the players
    RXMLElement *coachingYears = [rxml childElementWithTag:@"players.coach.experience.years"];
    
    STAssertEquals(coachingYears.textAsInt, 1, nil);
}

- (void)testDeepChildQueryWithWildcard {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    
    // count the players
    RXMLElement *coachingYears = [rxml childElementWithTag:@"players.coach.experience.teams.*"];
    
    // first team returned
    STAssertEquals(coachingYears.textAsInt, 53, nil);
}

@end
