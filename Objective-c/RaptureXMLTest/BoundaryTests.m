//
//  BoundaryTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RXMLElement.h"

@interface BoundaryTests : XCTestCase {
    NSString *emptyXML_;
    NSString *emptyTopTagXML_;
    NSString *childXML_;
    NSString *childrenXML_;
    NSString *attributeXML_;
    NSString *namespaceXML_;
}

@end



@implementation BoundaryTests

- (void)setUp {
    emptyXML_ = @"";
    emptyTopTagXML_ = @"<top></top>";
    childXML_ = @"<top><empty_child></empty_child><text_child>foo</text_child></top>";
    childrenXML_ = @"<top><child></child><child></child><child></child></top>";
    attributeXML_ = @"<top foo=\"bar\"></top>";
    namespaceXML_ = @"<ns:top xmlns:ns=\"*\" ns:foo=\"bar\" ns:one=\"1\"><ns:text>something</ns:text></ns:top>";
}

- (void)testEmptyXML {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:emptyXML_ encoding:NSUTF8StringEncoding];
    XCTAssertFalse(rxml.isValid);
}

- (void)testEmptyTopTagXML {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:emptyTopTagXML_ encoding:NSUTF8StringEncoding];
    XCTAssertTrue(rxml.isValid);
    XCTAssertEqualObjects(rxml.text, @"");
    XCTAssertEqualObjects([rxml childrenWithRootXPath:@"*"], [NSArray array]);
}

- (void)testAttribute {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:attributeXML_ encoding:NSUTF8StringEncoding];
    XCTAssertTrue(rxml.isValid);
    XCTAssertEqualObjects([rxml attribute:@"foo"], @"bar");
}

- (void)testNamespaceAttribute {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:namespaceXML_ encoding:NSUTF8StringEncoding];
    XCTAssertTrue(rxml.isValid);
    XCTAssertEqualObjects([rxml attribute:@"foo" inNamespace:@"*"], @"bar");
    XCTAssertEqual([rxml attributeAsInt:@"one" inNamespace:@"*"], 1);
}

- (void)testChild {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:childXML_ encoding:NSUTF8StringEncoding];
    XCTAssertTrue(rxml.isValid);
    XCTAssertEqualObjects([rxml child:@"empty_child"].text, @"");
    XCTAssertEqualObjects([rxml child:@"text_child"].text, @"foo");
}

- (void)testNamespaceChild {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:namespaceXML_ encoding:NSUTF8StringEncoding];
    XCTAssertTrue(rxml.isValid);
    XCTAssertEqualObjects([rxml child:@"text" inNamespace:@"*"].text, @"something");
}

- (void)testChildren {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:childrenXML_ encoding:NSUTF8StringEncoding];
    XCTAssertTrue(rxml.isValid);
    XCTAssertEqual([rxml children:@"child"].count, 3U);
}

- (void)testNamespaceChildren {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:namespaceXML_ encoding:NSUTF8StringEncoding];
    XCTAssertTrue(rxml.isValid);
    XCTAssertEqual([rxml children:@"text" inNamespace:@"*"].count, 1U);
}

@end
