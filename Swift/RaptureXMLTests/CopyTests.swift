//
//  CopyTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class CopyTests: XCTestCase {
    
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
    
    
    
    func testInterruptedText() {
        let rxml = RXMLElement(fromXMLString:interruptedTextXML_, encoding: NSUTF8StringEncoding);
        let rxml2 : RXMLElement = rxml.copy() as RXMLElement;
        XCTAssertEqual(rxml2.text, "thisisinterruptedtext");
    }
    
    func testCDataText() {
        let rxml = RXMLElement(fromXMLString:cdataXML_, encoding: NSUTF8StringEncoding);
        let rxml2 : RXMLElement = rxml.copy() as RXMLElement;
        XCTAssertEqual(rxml2.text, "thisiscdata");
    }
    
    func testTags() {
        let rxml = RXMLElement(fromXMLString:simplifiedXML_, encoding: NSUTF8StringEncoding);
        let rxml2 : RXMLElement = rxml.copy() as RXMLElement;
        
        var i = 0;
        rxml2.iterate("*", usingBlock: { (e : RXMLElement!) -> Void in
            if (i == 0) {
                XCTAssertEqual(e.tag, "square");
                XCTAssertEqual(e.text, "Square");
            } else if (i == 1) {
                XCTAssertEqual(e.tag, "triangle");
                XCTAssertEqual(e.text, "Triangle");
            } else if (i == 2) {
                XCTAssertEqual(e.tag, "circle");
                XCTAssertEqual(e.text, "Circle");
            }
            i++;
        });
        XCTAssertEqual(i, 3);
    }
    
    func testAttributes() {
        let rxml = RXMLElement(fromXMLString:attributedXML_, encoding: NSUTF8StringEncoding);
        let rxml2 : RXMLElement = rxml.copy() as RXMLElement;
        
        var i = 0;
        rxml2.iterate("*", usingBlock: { (e : RXMLElement!) -> Void in
            if (i == 0) {
                XCTAssertEqual(e.attribute("name"), "Square");
            } else if (i == 1) {
                XCTAssertEqual(e.attribute("name"), "Triangle");
            } else if (i == 2) {
                XCTAssertEqual(e.attribute("name"), "Circle");
            }
            i++;
        });
        XCTAssertEqual(i, 3);
    }
    
    
    
    
    
}
