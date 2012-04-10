//
//  SimpleTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RXMLElement.h"

@interface SimpleTests : SenTestCase {
    NSString *simplifiedXML_;
    NSString *attributedXML_;
    NSString *interruptedTextXML_;
    NSString *cdataXML_;
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
    RXMLElement *rxml = [RXMLElement elementWithString:interruptedTextXML_ encoding:NSUTF8StringEncoding];
    STAssertEqualObjects(rxml.text, @"thisisinterruptedtext", nil);
}

- (void)testCDataText {
    RXMLElement *rxml = [RXMLElement elementWithString:cdataXML_ encoding:NSUTF8StringEncoding];
    STAssertEqualObjects(rxml.text, @"thisiscdata", nil);
}

- (void)testTags {
    RXMLElement *rxml = [RXMLElement elementWithString:simplifiedXML_ encoding:NSUTF8StringEncoding];
    __block NSInteger i = 0;
    
    [rxml iterate:@"*" with:^(RXMLElement *e) {
        if (i == 0) {
            STAssertEqualObjects(e.tag, @"square", nil);
            STAssertEqualObjects(e.text, @"Square", nil);
        } else if (i == 1) {
            STAssertEqualObjects(e.tag, @"triangle", nil);            
            STAssertEqualObjects(e.text, @"Triangle", nil);
        } else if (i == 2) {
            STAssertEqualObjects(e.tag, @"circle", nil);            
            STAssertEqualObjects(e.text, @"Circle", nil);
        }

        i++;
    }];
    
    STAssertEquals(i, 3, nil);
}

- (void)testAttributes {
    RXMLElement *rxml = [RXMLElement elementWithString:attributedXML_ encoding:NSUTF8StringEncoding];
    __block NSInteger i = 0;
    
    [rxml iterate:@"*" with:^(RXMLElement *e) {
        if (i == 0) {
            STAssertEqualObjects([e attribute:@"name"], @"Square", nil);
        } else if (i == 1) {
            STAssertEqualObjects([e attribute:@"name"], @"Triangle", nil);            
        } else if (i == 2) {
            STAssertEqualObjects([e attribute:@"name"], @"Circle", nil);            
        }
        
        i++;
    }];
    
    STAssertEquals(i, 3, nil);
}

@end
