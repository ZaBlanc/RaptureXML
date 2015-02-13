//
//  EncodingTests.swift
//  RaptureXML-Swift
//
//  Created by Brett Lamy on 2/12/15.
//  Copyright (c) 2015 Brett Lamy. All rights reserved.
//

import UIKit
import XCTest

class EncodingTests: XCTestCase {

    var chineseXML_ = "<condition data=\"以晴为主\"/>";

    func testChinese() {
        let rxml = RXMLElement(fromXMLString:chineseXML_, encoding: NSUTF8StringEncoding);
        XCTAssertEqual(rxml.attribute("data"), "以晴为主");
    }
}
