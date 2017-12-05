//
//  ErrorTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RXMLElement.h"

@interface ErrorTests : XCTestCase {
    NSString *simplifiedXML_;
    NSString *badXML_;
}

@end



@implementation ErrorTests

- (void)setUp {
    simplifiedXML_ = @"\
        <shapes>\
            <square>Square</square>\
            <triangle>Triangle</triangle>\
            <circle>Circle</circle>\
        </shapes>";
    badXML_ = @"</xml";
}

- (void)testBadXML {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:badXML_ encoding:NSUTF8StringEncoding];
    XCTAssertFalse([rxml isValid]);
}

- (void)testMissingTag {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:simplifiedXML_ encoding:NSUTF8StringEncoding];
    RXMLElement *hexagon = [rxml child:@"hexagon"];
    
    XCTAssertNil(hexagon);
}

- (void)testMissingTagIteration {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:simplifiedXML_ encoding:NSUTF8StringEncoding];
    __block NSInteger i = 0;
    
    [rxml iterate:@"hexagon" usingBlock:^(RXMLElement *e) {
        i++;
    }];
     
    XCTAssertEqual(i, 0);
}

- (void)testMissingAttribute {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:simplifiedXML_ encoding:NSUTF8StringEncoding];
    NSString *missingName = [rxml attribute:@"name"];
    
    XCTAssertNil(missingName);
}

@end
