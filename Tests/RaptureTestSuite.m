//
//  RaptureTestSuite.m
//  RaptureXML
//
//  Created by Evan Maloney on 4/5/17.
//  Copyright © 2017 Gilt Groupe. All rights reserved.
//

#import "RaptureTestSuite.h"

@implementation RaptureTestSuite

- (RXMLElement*) testXML
{
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* xmlPath = [[bundle bundlePath] stringByAppendingPathComponent:@"players.xml"];
    RXMLElement* rxml = [RXMLElement elementFromXMLFilePath:xmlPath];
    XCTAssertTrue(rxml.isValid);
    return rxml;
}

@end
