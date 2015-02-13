//
//  DeepChildrenTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//


import UIKit
import XCTest

class DeepChildrenTests: XCTestCase {
    
    func testInterruptedText() {
        let rxml = RXMLElement(fromXMLFile:"players.xml");
        var i = 0;
        
        let players = rxml.child("players");
        let children : NSArray = players.children("player");
        
        rxml.iterateElements(children, usingBlock: { (e : RXMLElement!) -> Void in
            i += 1;
        });
        
        XCTAssertEqual(i, 9);
    }
    
    func testDeepChildQuery() {
        let rxml = RXMLElement(fromXMLFile:"players.xml");
        
        let coachingYears = rxml.child("players.coach.experience.years");
        
        XCTAssertEqual(coachingYears.textAsInt, 1);
    }
    
    func testDeepChildQueryWithWildcard() {
        let rxml = RXMLElement(fromXMLFile:"players.xml");
        
        let coachingYears = rxml.child("players.coach.experience.teams.*");
        
        XCTAssertEqual(coachingYears.textAsInt, 53);
    }

}
