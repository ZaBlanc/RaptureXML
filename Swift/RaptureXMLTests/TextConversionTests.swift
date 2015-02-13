//
//  TextConversionTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class TextConversionTests: XCTestCase {
    let simplifiedXML_ = "" +
    "<shapes>" +
        "<square>" +
            "<id>1</id>" +
            "<name>Square</name>" +
        "</square>" +
        "<triangle>" +
            "<id>2.5</id>" +
            "<name>Triangle</name>" +
        "</triangle>" +
    "</shapes>";
    
    let attributedXML_ = "" +
    "<shapes>" +
        "<square id=\"1\">" +
            "<name>Square</name>" +
        "</square>" +
        "<triangle id=\"2.5\">" +
            "<name>Triangle</name>" +
        "</triangle>" +
    "</shapes>";


    func testExample() {
        let rxml = RXMLElement(fromXMLString: simplifiedXML_, encoding: NSUTF8StringEncoding);
        var i = 0;
        
        rxml.iterate("*", usingBlock: { (e : RXMLElement!) -> Void in
            if (i == 0) {
                XCTAssertEqual(e.child("id").textAsInt, 1);
            } else if (i == 1) {
                XCTAssertEqualWithAccuracy(e.child("id").textAsDouble, 2.5, 0.01);
            }
            
            i++;
        })
    }
    
    func testIntAttributes() {
        let rxml = RXMLElement(fromXMLString: attributedXML_, encoding: NSUTF8StringEncoding);
        var i = 0;
        
        rxml.iterate("*", usingBlock: { (e : RXMLElement!) -> Void in
            if (i == 0) {
                XCTAssertEqual(e.attributeAsInt("id"), 1);
            } else if (i == 1) {
                XCTAssertEqualWithAccuracy(e.attributeAsDouble("id"), 2.5, 0.01);
            } else if (i == 2) {
                XCTAssertEqual(e.attributeAsInt("id"), 3);
            }
            
            i++;
        })
    }



}
