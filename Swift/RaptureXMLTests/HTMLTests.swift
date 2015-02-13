//
//  HTMLTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class HTMLTests: XCTestCase {

    let simpleHTML_ = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"" +
    "\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">" +
    "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" >" +
    "<head>" +
    "<title>Minimal XHTML 1.1 Document</title>" +
    "</head>" +
    "<body>" +
    "<p>This is a minimal <a href=\"http://www.w3.org/TR/xhtml11\">XHTML 1.1</a> document.</p>" +
    "</body>" +
    "</html>";

    func testBasicXHTML() {
        let html = RXMLElement(fromHTMLString:simpleHTML_, encoding: NSUTF8StringEncoding);
        let atts : NSArray = html.attributeNames();
        XCTAssertEqual(atts.count, 2);

        let children : NSArray = html.childrenWithRootXPath("//html/body/p");
        XCTAssertTrue(children.count > 0);

        let child : RXMLElement = children[0] as RXMLElement;
        XCTAssertEqual(child.text, "This is a minimal XHTML 1.1 document.");
    }
    
    func testHtmlEntity() {
        let html = RXMLElement(fromHTMLString:"<p>Don&apos;t say &quot;lazy&quot;</p>", encoding: NSUTF8StringEncoding);
        XCTAssertEqual(html.text, "Don't say \"lazy\"");
    }
    
    
    func testFixBrokenHtml() {
        let html = RXMLElement(fromHTMLString:"<p><b>Test</p> Broken HTML</b>", encoding: NSUTF8StringEncoding);
        XCTAssertEqual(html.text, "Test Broken HTML");
        XCTAssertEqual(html.xml, "<html><body><p><b>Test</b></p> Broken HTML</body></html>");
    }


}
