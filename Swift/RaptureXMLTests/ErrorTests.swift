//
//  ErrorTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class ErrorTests: XCTestCase {
    var simplifiedXML_ = "" +
    "<shapes>" +
    "<square>Square</square>" +
    "<triangle>Triangle</triangle>" +
    "<circle>Circle</circle>" +
    "</shapes>";
    var badXML_ = "</xml";
   
    func testBadXML() {
        let rxml = RXMLElement(fromXMLString:badXML_, encoding: NSUTF8StringEncoding);
        XCTAssertFalse(rxml.isValid);
    }

    func testMissingTag() {
        let rxml = RXMLElement(fromXMLString:simplifiedXML_, encoding: NSUTF8StringEncoding);
        let hexagon = rxml.child("hexagon");
        XCTAssertNil(hexagon);
    }
    
    func testMissingTagIteration() {
        let rxml = RXMLElement(fromXMLString:simplifiedXML_, encoding: NSUTF8StringEncoding);
        var i = 0;
        
        rxml.iterate("hexagon", usingBlock: { (e : RXMLElement!) -> Void in
            i+=1;
        })
        
        XCTAssertEqual(i, 0);
    }
    
    func testMissingAttribute() {
        let rxml = RXMLElement(fromXMLString:simplifiedXML_, encoding: NSUTF8StringEncoding);
        var missingName = rxml.attribute("name");
        
        XCTAssertNil(missingName);
    }
    

}
