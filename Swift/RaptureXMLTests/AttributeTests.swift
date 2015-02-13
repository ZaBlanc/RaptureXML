//
//  AttributeTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class AttributeTests: XCTestCase {

    let attributedXML_ = "" +
    "<shapes count=\"3\" style=\"basic\">" +
        "<square name=\"Square\" id=\"8\" sideLength=\"5\" />" +
        "<triangle name=\"Triangle\" style=\"equilateral\" />" +
        "<circle name=\"Circle\" />" +
    "</shapes>";


    func testAttributedText() {
        let rxml = RXMLElement(fromXMLString: attributedXML_, encoding: NSUTF8StringEncoding);
        var atts : NSArray = rxml.attributeNames();
        XCTAssertEqual(atts.count, 2);
        XCTAssertTrue(atts.containsObject("count"));
        XCTAssertTrue(atts.containsObject("style"));
        
        let squarexml = rxml.child("square");
        atts = squarexml.attributeNames();
        XCTAssertEqual(atts.count, 3);
        XCTAssertTrue(atts.containsObject("name"));
        XCTAssertTrue(atts.containsObject("id"));
        XCTAssertTrue(atts.containsObject("sideLength"));
    }

}
