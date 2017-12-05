//
//  HTMLTests.m
//  RaptureXML
//
//  Created by Francis Chong on 22/3/13.
//  Copyright (c) 2013 Rapture In Venice. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RXMLElement.h"

@interface HTMLTests : XCTestCase {
    NSString *simpleHTML_;
}
@end

@implementation HTMLTests

- (void)setUp {
    simpleHTML_ = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\
    <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"\
    \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\
    <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" >\
    <head>\
    <title>Minimal XHTML 1.1 Document</title>\
    </head>\
    <body>\
    <p>This is a minimal <a href=\"http://www.w3.org/TR/xhtml11\">XHTML 1.1</a> document.</p>\
    </body>\
    </html>";
}

- (void)testBasicXHTML {
    RXMLElement *html = [RXMLElement elementFromHTMLString:simpleHTML_ encoding:NSUTF8StringEncoding];
    NSArray *atts = [html attributeNames];
    XCTAssertEqual(atts.count, 2U);
    
    NSArray* children = [html childrenWithRootXPath:@"//html/body/p"];
    XCTAssertTrue([children count] > 0);

    RXMLElement* child = [children objectAtIndex:0];
    NSLog(@"content: %@", [child text]);
    XCTAssertEqualObjects([child text], @"This is a minimal XHTML 1.1 document.");
}

-(void) testHtmlEntity {
    RXMLElement* html = [RXMLElement elementFromHTMLString:@"<p>Don&apos;t say &quot;lazy&quot;</p>" encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects([html text], @"Don't say \"lazy\"");
}

-(void) testFixBrokenHtml {
    RXMLElement* html = [RXMLElement elementFromHTMLString:@"<p><b>Test</p> Broken HTML</b>" encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects([html text], @"Test Broken HTML");
    XCTAssertEqualObjects([html xml], @"<html><body><p><b>Test</b></p> Broken HTML</body></html>");
}

@end
