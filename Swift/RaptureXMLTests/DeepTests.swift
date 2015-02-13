//
//  DeepTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class DeepTests: XCTestCase {

    func testQuery() {
        let rxml = RXMLElement(fromXMLFile:"players.xml");
        
        // count the players
        var i = 0;
        
        rxml.iterate("players.player", usingBlock: { (e : RXMLElement!) -> Void in
            i += 1;
        });
        
        XCTAssertEqual(i, 9);
        
        // count the first player's name
        i = 0;
        
        rxml.iterate("players.player.name", usingBlock: { (e : RXMLElement!) -> Void in
            i += 1;
        });
        
        XCTAssertEqual(i, 1);
        
        // count the coaches
        i = 0;
        
        rxml.iterate("players.coach", usingBlock: { (e : RXMLElement!) -> Void in
            i += 1;
        });
        
        XCTAssertEqual(i, 1);
    }
}
