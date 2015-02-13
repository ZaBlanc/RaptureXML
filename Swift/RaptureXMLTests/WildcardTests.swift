//
//  WildcardTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class WildcardTests: XCTestCase {

    func testEndingWildcard() {
        let rxml = RXMLElement(fromXMLFile:"players.xml");
        var i = 0;
        
        rxml.iterate("players.*", usingBlock: { (e : RXMLElement!) -> Void in
            i += 1;
        });
        
        XCTAssertEqual(i, 10);
    }

    func testMidstreamWildcard() {
        let rxml = RXMLElement(fromXMLFile:"players.xml");
        var i = 0;
        
        rxml.iterate("players.*.name", usingBlock: { (e : RXMLElement!) -> Void in
            i += 1;
        });
        
        XCTAssertEqual(i, 10);
        
        i = 0;
        
        rxml.iterate("players.*.position", usingBlock: { (e : RXMLElement!) -> Void in
            i += 1;
        });
        
        XCTAssertEqual(i, 9);
    }
}
