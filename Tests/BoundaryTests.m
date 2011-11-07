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
}

@end



@implementation BoundaryTests

- (void)setUp {
    emptyXML_ = @"";
    emptyTopTagXML_ = @"<top></top>";
}

- (void)testEmptyXML {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:emptyXML_];
    STAssertFalse(rxml.isValid, nil);
}

- (void)testEmptyTopTagXML {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:emptyTopTagXML_];
    STAssertTrue(rxml.isValid, nil);
    STAssertEqualObjects(@"", rxml.text, nil);
    STAssertEqualObjects([rxml children:@"*"], [NSArray array], nil);
}

@end
