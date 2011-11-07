// ================================================================================================
//  RXMLElement.m
//  Fast processing of XML files
//
// ================================================================================================
//  Created by John Blanco on 9/23/11.
//  Version 1.4
//  
//  Copyright (c) 2011 John Blanco
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// ================================================================================================
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

- (NSInteger)textAsInt {
    return [self.text intValue];
}

- (double)textAsDouble {
    return [self.text doubleValue];
}

- (NSString *)attribute:(NSString *)attName {
    return [TBXML valueOfAttributeNamed:attName forElement:tbxmlElement_];
}

- (NSInteger)attributeAsInt:(NSString *)attName {
    return [[self attribute:attName] intValue];
}

- (double)attributeAsDouble:(NSString *)attName {
    return [[self attribute:attName] doubleValue];
}

- (BOOL)isValid {
    return (tbxmlElement_ != nil);
}

#pragma mark -

- (RXMLElement *)child:(NSString *)tagName {
    NSArray *components = [tagName componentsSeparatedByString:@"."];
    TBXMLElement *currTBXMLElement = tbxmlElement_;
    
    // navigate down
    for (NSInteger i=0; i < components.count; ++i) {
        NSString *iTagName = [components objectAtIndex:i];
        
        if ([iTagName isEqualToString:@"*"]) {
            currTBXMLElement = [TBXML childElementNamed:nil parentElement:currTBXMLElement];
        } else {
            currTBXMLElement = [TBXML childElementNamed:iTagName parentElement:currTBXMLElement];            
        }
        
        if (!currTBXMLElement) {
            break;
        }
    }
    
    if (currTBXMLElement) {
        return [RXMLElement elementFromTBXMLElement:currTBXMLElement];
    }
    
    return nil;
}

- (NSArray *)children:(NSString *)tagName {
    NSMutableArray *children = [NSMutableArray array];
    TBXMLElement *currTBXMLElement = [TBXML childElementNamed:tagName parentElement:tbxmlElement_];
    
    if (currTBXMLElement) {
        do {
            [children addObject:[RXMLElement elementFromTBXMLElement:currTBXMLElement]];
        } while ((currTBXMLElement = [TBXML nextSiblingNamed:tagName searchFromElement:currTBXMLElement]));        
    }
    
    return [[children copy] autorelease];
}

#pragma mark -

- (void)iterate:(NSString *)query with:(void (^)(RXMLElement *))blk {
    NSArray *components = [query componentsSeparatedByString:@"."];
    TBXMLElement *currTBXMLElement = tbxmlElement_;

    // navigate down
    for (NSInteger i=0; i < components.count; ++i) {
        NSString *iTagName = [components objectAtIndex:i];
        
        if ([iTagName isEqualToString:@"*"]) {
            currTBXMLElement = [TBXML childElementNamed:nil parentElement:currTBXMLElement];

            // different behavior depending on if this is the end of the query or midstream
            if (i < (components.count - 1)) {
                // midstream
                do {
                    RXMLElement *element = [RXMLElement elementFromTBXMLElement:currTBXMLElement];
                    NSString *restOfQuery = [[components subarrayWithRange:NSMakeRange(i + 1, components.count - i - 1)] componentsJoinedByString:@"."];
                    [element iterate:restOfQuery with:blk];
                } while ((currTBXMLElement = [TBXML nextSiblingNamed:nil searchFromElement:currTBXMLElement]));
                    
            }
        } else {
            currTBXMLElement = [TBXML childElementNamed:iTagName parentElement:currTBXMLElement];            
        }

        if (!currTBXMLElement) {
            break;
        }
    }
    
    if (currTBXMLElement) {
        // enumerate
        NSString *childTagName = [components lastObject];
        
        if ([childTagName isEqualToString:@"*"]) {
            childTagName = nil;
        }

        do {
            RXMLElement *element = [RXMLElement elementFromTBXMLElement:currTBXMLElement];
            blk(element);
        } while ((currTBXMLElement = [TBXML nextSiblingNamed:childTagName searchFromElement:currTBXMLElement]));
    }
}

- (void)iterateElements:(NSArray *)elements with:(void (^)(RXMLElement *))blk {
    for (RXMLElement *iElement in elements) {
        blk(iElement);
    }
}

@end
