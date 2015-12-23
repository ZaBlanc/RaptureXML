//
//  RaptureXML.h
//
//  Created by Evan Maloney on 12/22/15.
//  Copyright © 2015 Gilt Groupe. All rights reserved.
//

#ifndef __OBJC__

#error RaptureXML requires Objective-C

#else

#import <Foundation/Foundation.h>

//! Project version number for RaptureXML.
FOUNDATION_EXPORT double RaptureXMLVersionNumber;

//! Project version string for RaptureXML.
FOUNDATION_EXPORT const unsigned char RaptureXMLVersionString[];

// XML library dependencies

#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>
#import <libxml2/libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>

// import the public headers

#import <RaptureXML/RXMLElement.h>

#endif

