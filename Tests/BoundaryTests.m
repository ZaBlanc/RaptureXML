//
//  BoundaryTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RXMLElement.h"

@interface BoundaryTests : SenTestCase {
    NSString *emptyXML_;
    NSString *emptyTopTagXML_;
    NSString *childXML_;
    NSString *childrenXML_;
    NSString *attributeXML_;
}

@end



@implementation BoundaryTests

- (void)setUp {
    emptyXML_ = @"";
    emptyTopTagXML_ = @"<top></top>";
    childXML_ = @"<top><empty_child></empty_child><text_child>foo</text_child></top>";
    childrenXML_ = @"<top><child></child><child></child><child></child></top>";
    attributeXML_ = @"<top foo=\"bar\"></top>";
}

- (void)testEmptyXML {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:emptyXML_ withEncoding:NSUTF8StringEncoding];
    STAssertFalse(rxml.isValid, nil);
}

- (void)testEmptyTopTagXML {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:emptyTopTagXML_ withEncoding:NSUTF8StringEncoding];
    STAssertTrue(rxml.isValid, nil);
    STAssertEqualObjects(rxml.text, @"", nil);
    STAssertEqualObjects([rxml children:@"*"], [NSArray array], nil);
}

- (void)testAttribute {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:attributeXML_ withEncoding:NSUTF8StringEncoding];
    STAssertTrue(rxml.isValid, nil);
    STAssertEqualObjects([rxml attribute:@"foo"], @"bar", nil);
}

- (void)testChild {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:childXML_ withEncoding:NSUTF8StringEncoding];
    STAssertTrue(rxml.isValid, nil);
    STAssertEqualObjects([rxml child:@"empty_child"].text, @"", nil);
    STAssertEqualObjects([rxml child:@"text_child"].text, @"foo", nil);
}

- (void)testChildren {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:childrenXML_ withEncoding:NSUTF8StringEncoding];
    STAssertTrue(rxml.isValid, nil);
    STAssertEquals([rxml children:@"child"].count, 3U, nil);
}

@end
