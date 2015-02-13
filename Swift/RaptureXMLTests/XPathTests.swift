//
//  XPathTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class XPathTests: XCTestCase {
    let simplifiedXML_ = "" +
        "<shapes>" +
        "<square>Square</square>" +
        "<triangle>Triangle</triangle>" +
        "<circle>Circle</circle>" +
    "</shapes>";
    
    let attributedXML_ = "" +
        "<shapes>" +
        "<square name=\"Square\" />" +
        "<triangle name=\"Triangle\" />" +
        "<circle name=\"Circle\" />" +
    "</shapes>";
    
    let interruptedTextXML_ = "<top><a>this</a>is<a>interrupted</a>text<a></a></top>";
    let cdataXML_ = "<top><![CDATA[this]]><![CDATA[is]]><![CDATA[cdata]]></top>";
    
    


    func testBasicPath() {
        let rxml = RXMLElement(fromXMLString:simplifiedXML_, encoding: NSUTF8StringEncoding);
        var i = 0;
        
        rxml.iterateWithRootXPath("//circle", usingBlock: { (element : RXMLElement!) -> Void in
            XCTAssertEqual(element.text, "Circle");
            i += 1;
        });
        
        XCTAssertEqual(i, 1);
    }

    func testAttributePath() {
        let rxml = RXMLElement(fromXMLString:attributedXML_, encoding: NSUTF8StringEncoding);
        var i = 0;
        
        rxml.iterateWithRootXPath("//circle[@name='Circle']", usingBlock: { (element : RXMLElement!) -> Void in
            XCTAssertEqual(element.attribute("name"), "Circle");
            i += 1;
        });
        
        XCTAssertEqual(i, 1);
    }

}
