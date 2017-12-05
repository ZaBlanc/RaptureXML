//
//  AttributeTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RXMLElement.h"

@interface AttributeTests : XCTestCase {
    NSString *attributedXML_;
}

@end

@implementation AttributeTests

- (void)setUp {
    attributedXML_ = @"\
    <shapes count=\"3\" style=\"basic\">\
    <square name=\"Square\" id=\"8\" sideLength=\"5\" />\
    <triangle name=\"Triangle\" style=\"equilateral\" />\
    <circle name=\"Circle\" />\
    </shapes>";
}

- (void)testAttributedText {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:attributedXML_ encoding:NSUTF8StringEncoding];
    NSArray *atts = [rxml attributeNames];
    XCTAssertEqual(atts.count, 2U);
    XCTAssertTrue([atts containsObject:@"count"]);
    XCTAssertTrue([atts containsObject:@"style"]);

    RXMLElement *squarexml = [rxml child:@"square"];
    atts = [squarexml attributeNames];
    XCTAssertEqual(atts.count, 3U);
    XCTAssertTrue([atts containsObject:@"name"]);
    XCTAssertTrue([atts containsObject:@"id"]);
    XCTAssertTrue([atts containsObject:@"sideLength"]);
}

@end

