//
//  SimpleTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RXMLElement.h"

@interface SimpleTests : XCTestCase {
    NSString *simplifiedXML_;
    NSString *attributedXML_;
    NSString *interruptedTextXML_;
    NSString *cdataXML_;
    NSString *treeXML_;
}

@end



@implementation SimpleTests

- (void)setUp {
    simplifiedXML_ = @"\
        <shapes>\
            <square>Square</square>\
            <triangle>Triangle</triangle>\
            <circle>Circle</circle>\
        </shapes>";
    
    attributedXML_ = @"\
        <shapes>\
            <square name=\"Square\" />\
            <triangle name=\"Triangle\" />\
            <circle name=\"Circle\" />\
        </shapes>";
    interruptedTextXML_ = @"<top><a>this</a>is<a>interrupted</a>text<a></a></top>";
    cdataXML_ = @"<top><![CDATA[this]]><![CDATA[is]]><![CDATA[cdata]]></top>";

}

- (void)testInterruptedText {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:interruptedTextXML_ encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(rxml.text, @"thisisinterruptedtext");
}

- (void)testCDataText {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:cdataXML_ encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(rxml.text, @"thisiscdata");
}

- (void)testTags {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:simplifiedXML_ encoding:NSUTF8StringEncoding];
    __block NSInteger i = 0;
    
    [rxml iterate:@"*" usingBlock:^(RXMLElement *e) {
        if (i == 0) {
            XCTAssertEqualObjects(e.tag, @"square");
            XCTAssertEqualObjects(e.text, @"Square");
        } else if (i == 1) {
            XCTAssertEqualObjects(e.tag, @"triangle");            
            XCTAssertEqualObjects(e.text, @"Triangle");
        } else if (i == 2) {
            XCTAssertEqualObjects(e.tag, @"circle");            
            XCTAssertEqualObjects(e.text, @"Circle");
        }

        i++;
    }];
    
    XCTAssertEqual(i, 3);
}

- (void)testAttributes {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:attributedXML_ encoding:NSUTF8StringEncoding];
    __block NSInteger i = 0;
    
    [rxml iterate:@"*" usingBlock:^(RXMLElement *e) {
        if (i == 0) {
            XCTAssertEqualObjects([e attribute:@"name"], @"Square");
        } else if (i == 1) {
            XCTAssertEqualObjects([e attribute:@"name"], @"Triangle");            
        } else if (i == 2) {
            XCTAssertEqualObjects([e attribute:@"name"], @"Circle");            
        }
        
        i++;
    }];
    
    XCTAssertEqual(i, 3);
}

-(void) testInnerXml {    
    treeXML_ = @"<data>\
    <shapes><circle>Circle</circle></shapes>\
    <colors>TEST<rgb code=\"0,0,0\">Black<annotation>default color</annotation></rgb></colors>\
</data>";

    RXMLElement *rxml = [RXMLElement elementFromXMLString:treeXML_ encoding:NSUTF8StringEncoding];
    RXMLElement* shapes = [rxml child:@"shapes"];
    XCTAssertEqualObjects(shapes.xml, @"<shapes><circle>Circle</circle></shapes>");
    XCTAssertEqualObjects(shapes.innerXml, @"<circle>Circle</circle>");

    RXMLElement* colors = [rxml child:@"colors"];
    XCTAssertEqualObjects(colors.xml, @"<colors>TEST<rgb code=\"0,0,0\">Black<annotation>default color</annotation></rgb></colors>");
    XCTAssertEqualObjects(colors.innerXml, @"TEST<rgb code=\"0,0,0\">Black<annotation>default color</annotation></rgb>");
    
    RXMLElement *cdata = [RXMLElement elementFromXMLString:cdataXML_ encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(cdata.xml, @"<top><![CDATA[thisiscdata]]></top>");
    XCTAssertEqualObjects(cdata.innerXml, @"<![CDATA[thisiscdata]]>");
}

@end
