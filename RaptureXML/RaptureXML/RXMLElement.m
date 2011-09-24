//
//  RXMLElement.m
//  RaptureXML
//
//  Created by John Blanco on 9/23/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "RXMLElement.h"

@implementation RXMLElement

- (id)initFromXMLString:(NSString *)xmlString {
    if ((self = [super init])) {
        xml_ = [[TBXML alloc] initWithXMLString:xmlString];
        tbxmlElement_ = xml_.rootXMLElement;
    }
    
    return self;    
}

- (id)initFromXMLFile:(NSString *)filename {
    if ((self = [super init])) {
        xml_ = [[TBXML alloc] initWithXMLFile:filename];
        tbxmlElement_ = xml_.rootXMLElement;
    }
    
    return self;    
}

- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString*)extension {
    if ((self = [super init])) {
        xml_ = [[TBXML alloc] initWithXMLFile:filename fileExtension:extension];
        tbxmlElement_ = xml_.rootXMLElement;
    }
    
    return self;    
}

- (id)initFromURL:(NSURL *)url {
    if ((self = [super init])) {
        xml_ = [[TBXML alloc] initWithURL:url];
        tbxmlElement_ = xml_.rootXMLElement;
    }
    
    return self;    
}

- (id)initFromXMLData:(NSData *)data {
    if ((self = [super init])) {
        xml_ = [[TBXML alloc] initWithXMLData:data];
        tbxmlElement_ = xml_.rootXMLElement;
    }
    
    return self;    
}

- (id)initFromTBXMLElement:(TBXMLElement *)tbxmlElement {
    if ((self = [super init])) {
        tbxmlElement_ = tbxmlElement;
    }
    
    return self;
}

+ (id)elementFromXMLString:(NSString *)filename {
    return [[[RXMLElement alloc] initFromXMLString:filename] autorelease];    
}

+ (id)elementFromXMLFile:(NSString *)filename {
    return [[[RXMLElement alloc] initFromXMLFile:filename] autorelease];    
}

+ (id)elementFromXMLFilename:(NSString *)filename fileExtension:(NSString *)extension {
    return [[[RXMLElement alloc] initFromXMLFile:filename fileExtension:extension] autorelease];
}

+ (id)elementFromURL:(NSURL *)url {
    return [[[RXMLElement alloc] initFromURL:url] autorelease];
}

+ (id)elementFromXMLData:(NSData *)data {
    return [[[RXMLElement alloc] initFromXMLData:data] autorelease];
}

+ (id)elementFromTBXMLElement:(TBXMLElement *)tbxmlElement {
    return [[[RXMLElement alloc] initFromTBXMLElement:tbxmlElement] autorelease];
}

- (NSString *)description {
    return [self text];
}

- (void)dealloc {
    [xml_ release];
    [super dealloc];
}

#pragma mark -

- (NSString *)tag {
    return [TBXML elementName:tbxmlElement_];
}

- (NSString *)text {
    return [TBXML textForElement:tbxmlElement_];
}

- (NSString *)attribute:(NSString *)attName {
    return [TBXML valueOfAttributeNamed:attName forElement:tbxmlElement_];
}

#pragma mark -

- (RXMLElement *)child:(NSString *)tagName {
    return [RXMLElement elementFromTBXMLElement:[TBXML childElementNamed:tagName parentElement:tbxmlElement_]];
}

- (NSArray *)children:(NSString *)tagName {
    NSMutableArray *children = [NSMutableArray array];
    TBXMLElement *currTBXMLElement = [TBXML childElementNamed:tagName parentElement:tbxmlElement_];
    
    do {
        [children addObject:[RXMLElement elementFromTBXMLElement:currTBXMLElement]];
    } while ((currTBXMLElement = [TBXML nextSiblingNamed:tagName searchFromElement:currTBXMLElement]));        
    
    return [[children copy] autorelease];
}

#pragma mark -

- (void)iterate:(NSString *)query with:(void (^)(RXMLElement *))blk {
    NSArray *components = [query componentsSeparatedByString:@"."];
    TBXMLElement *currTBXMLElement = tbxmlElement_;
    
    // navigate down
    for (NSString *iTagName in components) {
        currTBXMLElement = [TBXML childElementNamed:iTagName parentElement:currTBXMLElement];
    }
    
    // enumerate
    NSString *childTagName = [components lastObject];
    
    do {
        RXMLElement *element = [RXMLElement elementFromTBXMLElement:currTBXMLElement];
        blk(element);
    } while ((currTBXMLElement = [TBXML nextSiblingNamed:childTagName searchFromElement:currTBXMLElement]));
}

- (void)iterateElements:(NSArray *)elements with:(void (^)(RXMLElement *))blk {
    for (RXMLElement *iElement in elements) {
        blk(iElement);
    }
}

@end
