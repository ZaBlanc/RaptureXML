//
//  BoundaryTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class BoundaryTests: XCTestCase {

    let emptyXML_ = "";
    let emptyTopTagXML_ = "<top></top>";
    let childXML_ = "<top><empty_child></empty_child><text_child>foo</text_child></top>";
    let childrenXML_ = "<top><child></child><child></child><child></child></top>";
    let attributeXML_ = "<top foo=\"bar\"></top>";
    let namespaceXML_ = "<ns:top xmlns:ns=\"*\" ns:foo=\"bar\" ns:one=\"1\"><ns:text>something</ns:text></ns:top>";


    
    func testEmptyXML() {
        let rxml = RXMLElement(fromXMLString:emptyXML_, encoding: NSUTF8StringEncoding);
        XCTAssertFalse(rxml.isValid);
    }
    
    func testEmptyTopTagXML() {
        let rxml = RXMLElement(fromXMLString:emptyTopTagXML_, encoding: NSUTF8StringEncoding);
        XCTAssertTrue(rxml.isValid);
        XCTAssertEqual(rxml.text, "");
        XCTAssertEqual(rxml.childrenWithRootXPath("*") as NSArray, []);
    }
    
    func testAttribute() {
        let rxml = RXMLElement(fromXMLString:attributeXML_, encoding: NSUTF8StringEncoding);
        XCTAssertTrue(rxml.isValid);
        XCTAssertEqual(rxml.attribute("foo"), "bar");
    }
    
    func testNamespaceAttribute() {
        let rxml = RXMLElement(fromXMLString:namespaceXML_, encoding: NSUTF8StringEncoding);
        XCTAssertTrue(rxml.isValid);
        XCTAssertEqual(rxml.attribute("foo", inNamespace: "*"), "bar");
        XCTAssertEqual(rxml.attributeAsInt("one", inNamespace: "*"), 1);
    }
    
    func testChild() {
        let rxml = RXMLElement(fromXMLString:childXML_, encoding: NSUTF8StringEncoding);
        XCTAssertTrue(rxml.isValid);
        XCTAssertEqual(rxml.child("empty_child").text, "");
        XCTAssertEqual(rxml.child("text_child").text, "foo");
    }
    
    func testNamespaceChild() {
        let rxml = RXMLElement(fromXMLString:namespaceXML_, encoding: NSUTF8StringEncoding);
        XCTAssertTrue(rxml.isValid);
        XCTAssertEqual(rxml.child("text", inNamespace:"*").text, "something");
    }
    
    func testChildren() {
        let rxml = RXMLElement(fromXMLString:childrenXML_, encoding: NSUTF8StringEncoding);
        XCTAssertTrue(rxml.isValid);
        XCTAssertEqual(rxml.children("child").count, 3);
    }

}
