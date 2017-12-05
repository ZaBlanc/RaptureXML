//
//  EncodingTests.m
//  RaptureXML
//
//  Created by John Blanco on 3/31/12.
//  Copyright (c) 2012 Rapture In Venice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RXMLElement.h"

@interface EncodingTests : XCTestCase {
    NSString *chineseXML_;
}

@end



@implementation EncodingTests

- (void)setUp {
    chineseXML_ = @"<condition data=\"以晴为主\"/>";
}

- (void)testChinese {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:chineseXML_ encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects([rxml attribute:@"data"], @"以晴为主");
}

@end
