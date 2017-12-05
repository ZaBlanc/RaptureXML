//
//  TextConversionTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RXMLElement.h"

@interface TextConversionTests : XCTestCase {
    NSString *simplifiedXML_;
    NSString *attributedXML_;
}

@end



@implementation TextConversionTests

- (void)setUp {
    simplifiedXML_ = @"\
        <shapes>\
            <square>\
                <id>1</id>\
                <name>Square</name>\
            </square>\
            <triangle>\
                <id>2.5</id>\
                <name>Triangle</name>\
            </triangle>\
        </shapes>";
    
    attributedXML_ = @"\
        <shapes>\
            <square id=\"1\">\
                <name>Square</name>\
            </square>\
            <triangle id=\"2.5\">\
                <name>Triangle</name>\
            </triangle>\
        </shapes>";
}

- (void)testIntTags {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:simplifiedXML_ encoding:NSUTF8StringEncoding];
    __block NSInteger i = 0;
    
    [rxml iterate:@"*" usingBlock:^(RXMLElement *e) {
        if (i == 0) {
            XCTAssertEqual([e child:@"id"].textAsInt, 1);
        } else if (i == 1) {
            XCTAssertEqualWithAccuracy([e child:@"id"].textAsDouble, 2.5, 0.01);
        }
        
        i++;
    }];
}

- (void)testIntAttributes {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:attributedXML_ encoding:NSUTF8StringEncoding];
    __block NSInteger i = 0;
    
    [rxml iterate:@"*" usingBlock:^(RXMLElement *e) {
        if (i == 0) {
            XCTAssertEqual([e attributeAsInt:@"id"], 1);
        } else if (i == 1) {
            XCTAssertEqualWithAccuracy([e attributeAsDouble:@"id"], 2.5, 0.01);
        } else if (i == 2) {
            XCTAssertEqual([e attributeAsInt:@"id"], 3);
        }
        
        i++;
    }];
}

@end
