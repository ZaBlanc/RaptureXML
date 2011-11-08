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
}

- (void)testTags {
    RXMLElement *rxml = [RXMLElement elementFromXMLString:simplifiedXML_];
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
    RXMLElement *rxml = [RXMLElement elementFromXMLString:attributedXML_];
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
