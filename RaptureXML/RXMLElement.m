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

@interface RXMLElement () {
    xmlDocPtr document_;
    xmlNodePtr node_;
}

- (void)setupWithData:(NSData *)data;

@end

@implementation RXMLElement 

- (id)initFromXMLString:(NSString *)xmlString withEncoding:(NSStringEncoding)encoding {
    if ((self = [super init])) {
        NSData *data = [xmlString dataUsingEncoding:encoding];
        
        [self setupWithData:data];
    }
    
    return self;    
}

- (id)initFromXMLFile:(NSString *)filename {
    if ((self = [super init])) {
        NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        
        [self setupWithData:data];
    }
    
    return self;    
}

- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString *)extension {
    if ((self = [super init])) {
        NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:extension];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        
        [self setupWithData:data];
    }
    
    return self;    
}

- (id)initFromURL:(NSURL *)url {
    if ((self = [super init])) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [self setupWithData:data];
    }
    
    return self;    
}

- (id)initFromXMLData:(NSData *)data {
    if ((self = [super init])) {
        [self setupWithData:data];
    }
    
    return self;    
}

- (id)initFromXMLNode:(xmlNodePtr)node {
    if ((self = [super init])) {
        document_ = nil;
        node_ = node;
    }
    
    return self;        
}

+ (id)elementFromXMLString:(NSString *)attributeXML_ withEncoding:(NSStringEncoding)encoding {
    return [[[RXMLElement alloc] initFromXMLString:attributeXML_ withEncoding:encoding] autorelease];    
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

+ (id)elementFromXMLNode:(xmlNodePtr)node {
    return [[[RXMLElement alloc] initFromXMLNode:node] autorelease];
}

- (NSString *)description {
    return [self text];
}

- (void)dealloc {
    if (document_ != nil) {
        xmlFreeDoc(document_);
    }
    
    [super dealloc];
}

#pragma mark -

- (NSString *)tag {
    return [NSString stringWithUTF8String:(const char *)node_->name];
}

- (NSString *)text {
    xmlChar *key = xmlNodeGetContent(node_);
    NSString *text = (key ? [NSString stringWithUTF8String:(const char *)key] : @"");
    xmlFree(key);
    
    return text;
}

- (NSInteger)textAsInteger {
    return [self.text integerValue];
}

- (double)textAsDouble {
    return [self.text doubleValue];
}

- (NSString *)attribute:(NSString *)attributeName {
    const unsigned char *attributeValueC = xmlGetProp(node_, (const xmlChar *)[attributeName cStringUsingEncoding:NSUTF8StringEncoding]);        
    
    if (attributeValueC != NULL) {
        return [NSString stringWithUTF8String:(const char *)attributeValueC];
    }
    
    return nil;
}

- (NSString *)attribute:(NSString *)attributeName inNamespace:(NSString *)xmlNamespace {
    const unsigned char *attributeValueC = xmlGetNsProp(node_, (const xmlChar *)[attributeName cStringUsingEncoding:NSUTF8StringEncoding], (const xmlChar *)[xmlNamespace cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (attributeValueC != NULL) {
        return [NSString stringWithUTF8String:(const char *)attributeValueC];
    }
    
    return nil;
}

- (NSInteger)attributeAsInteger:(NSString *)attributeName {
    return [[self attribute:attributeName] integerValue];
}

- (NSInteger)attributeAsInteger:(NSString *)attributeName inNamespace:(NSString *)xmlNamespace {
    return [[self attribute:attributeName inNamespace:xmlNamespace] integerValue];
}

- (double)attributeAsDouble:(NSString *)attributeName {
    return [[self attribute:attributeName] doubleValue];
}

- (double)attributeAsDouble:(NSString *)attributeName inNamespace:(NSString *)xmlNamespace {
    return [[self attribute:attributeName inNamespace:xmlNamespace] doubleValue];
}

- (BOOL)isValid {
    return document_ != nil;
}

#pragma mark -

- (RXMLElement *)child:(NSString *)tagName {
    NSArray *components = [tagName componentsSeparatedByString:@"."];
    xmlNodePtr currentNode = node_;
    
    // navigate down
    for (NSUInteger i=0; i < components.count; ++i) {
        NSString *iTagName = [components objectAtIndex:i];
        const xmlChar *tagNameC = (const xmlChar *)[iTagName cStringUsingEncoding:NSUTF8StringEncoding];
        
        if ([iTagName isEqualToString:@"*"]) {
            currentNode = currentNode->children;
            
            while (currentNode != NULL && currentNode->type != XML_ELEMENT_NODE) {
                currentNode = currentNode->next;
            }
        } else {
            currentNode = currentNode->children;
            while (currentNode != NULL) {
                if (currentNode->type == XML_ELEMENT_NODE && xmlStrcmp(currentNode->name, tagNameC) == 0) {
                    break;
                }
                
                currentNode = currentNode->next;
            }
        }
        
        if (currentNode == NULL) {
            break;
        }
    }
    
    if (currentNode != NULL) {
        return [RXMLElement elementFromXMLNode:currentNode];
    }
    
    return nil;
}

- (RXMLElement *)child:(NSString *)tagName inNamespace:(NSString *)xmlNamespace {
    NSArray *components = [tagName componentsSeparatedByString:@"."];
    xmlNodePtr currentNode = node_;
    const xmlChar *namespaceC = (const xmlChar *)[xmlNamespace cStringUsingEncoding:NSUTF8StringEncoding];
    
    // navigate down
    for (NSUInteger i=0; i < components.count; ++i) {
        NSString *iTagName = [components objectAtIndex:i];
        const xmlChar *tagNameC = (const xmlChar *)[iTagName cStringUsingEncoding:NSUTF8StringEncoding];
        
        if ([iTagName isEqualToString:@"*"]) {
            currentNode = currentNode->children;
            
            while (currentNode != NULL && currentNode->type != XML_ELEMENT_NODE && xmlStrcmp(currentNode->ns->href, namespaceC) == 0) {
                currentNode = currentNode->next;
            }
        } else {
            currentNode = currentNode->children;
            while (currentNode != NULL) {
                if (currentNode->type == XML_ELEMENT_NODE && xmlStrcmp(currentNode->name, tagNameC) == 0 && xmlStrcmp(currentNode->ns->href, namespaceC) == 0) {
                    break;
                }
                
                currentNode = currentNode->next;
            }
        }
        
        if (currentNode == NULL) {
            break;
        }
    }
    
    if (currentNode != NULL) {
        return [RXMLElement elementFromXMLNode:currentNode];
    }
    
    return nil;
}

- (NSArray *)children:(NSString *)tagName {
    const xmlChar *tagNameC = (const xmlChar *)[tagName cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *children = [NSMutableArray array];
    xmlNodePtr currentNode = node_->children;
    
    while (currentNode != NULL) {
        if (currentNode->type == XML_ELEMENT_NODE && xmlStrcmp(currentNode->name, tagNameC) == 0) {
            [children addObject:[RXMLElement elementFromXMLNode:currentNode]];
        }
        
        currentNode = currentNode->next;
    }
    
    return [[children copy] autorelease];
}

- (NSArray *)children:(NSString *)tagName inNamespace:(NSString *)xmlNamespace {
    const xmlChar *tagNameC = (const xmlChar *)[tagName cStringUsingEncoding:NSUTF8StringEncoding];
    const xmlChar *namespaceC = (const xmlChar *)[xmlNamespace cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *children = [NSMutableArray array];
    xmlNodePtr currentNode = node_->children;
    
    while (currentNode != NULL) {
        if (currentNode->type == XML_ELEMENT_NODE && xmlStrcmp(currentNode->name, tagNameC) == 0 && xmlStrcmp(currentNode->ns->href, namespaceC) == 0) {
            [children addObject:[RXMLElement elementFromXMLNode:currentNode]];
        }
        
        currentNode = currentNode->next;
    }
    
    return [[children copy] autorelease];
}

#pragma mark -

- (void)iterate:(NSString *)query with:(void (^)(RXMLElement *))block {
    NSArray *components = [query componentsSeparatedByString:@"."];
    xmlNodePtr currentNode = node_;
    
    // navigate down
    for (NSUInteger i=0; i < components.count; ++i) {
        NSString *iTagName = [components objectAtIndex:i];
        
        if ([iTagName isEqualToString:@"*"]) {
            currentNode = currentNode->children;
            
            // different behavior depending on if this is the end of the query or midstream
            if (i < (components.count - 1)) {
                // midstream
                do {
                    if (currentNode->type == XML_ELEMENT_NODE) {
                        RXMLElement *element = [RXMLElement elementFromXMLNode:currentNode];
                        NSString *restOfQuery = [[components subarrayWithRange:NSMakeRange(i + 1, components.count - i - 1)] componentsJoinedByString:@"."];
                        
                        [element iterate:restOfQuery with:block];
                    }
                    
                    currentNode = currentNode->next;
                } while (currentNode != nil);
                
            }
        } else {
            const xmlChar *tagNameC = (const xmlChar *)[iTagName cStringUsingEncoding:NSUTF8StringEncoding];
            
            currentNode = currentNode->children;
            while (currentNode != NULL) {
                if (currentNode->type == XML_ELEMENT_NODE && xmlStrcmp(currentNode->name, tagNameC) == 0) {
                    break;
                }
                
                currentNode = currentNode->next;
            }
        }
        
        if (currentNode == NULL) {
            break;
        }
    }
    
    if (currentNode != NULL) {
        // enumerate
        NSString *childTagName = [components lastObject];
        
        do {
            if (currentNode->type == XML_ELEMENT_NODE) {
                RXMLElement *element = [RXMLElement elementFromXMLNode:currentNode];
                block(element);
            }
            
            if ([childTagName isEqualToString:@"*"]) {
                currentNode = currentNode->next;
            } else {
                const xmlChar *tagNameC = (const xmlChar *)[childTagName cStringUsingEncoding:NSUTF8StringEncoding];
                
                while ((currentNode = currentNode->next) != NULL) {
                    if (currentNode->type == XML_ELEMENT_NODE && xmlStrcmp(currentNode->name, tagNameC) == 0) {
                        break;
                    }                    
                }
            }
        } while (currentNode != NULL);
    }
}

- (void)iterateElements:(NSArray *)elements with:(void (^)(RXMLElement *))block {
    for (RXMLElement *iElement in elements) {
        block(iElement);
    }
}

#pragma mark -

- (void)setupWithData:(NSData *)data {
    document_ = xmlReadMemory([data bytes], (int)[data length], "", nil, XML_PARSE_RECOVER);
    
    if ([self isValid]) {
        node_ = xmlDocGetRootElement(document_);
        
        if (node_ == NULL) {
            xmlFreeDoc(document_);
            document_ = nil;
        }
    }
}

@end
