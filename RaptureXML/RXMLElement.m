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

- (id)initFromXMLString:(NSString *)xmlString encoding:(NSStringEncoding)encoding {
    if ((self = [super init])) {
        NSData *data = [xmlString dataUsingEncoding:encoding];

        doc_ = xmlReadMemory([data bytes], [data length], "", nil, XML_PARSE_RECOVER);
        
        if ([self isValid]) {
            node_ = xmlDocGetRootElement(doc_);
            
            if (!node_) {
                xmlFreeDoc(doc_); doc_ = nil;
            }
        }
    }
    
    return self;    
}

- (id)initFromXMLFile:(NSString *)filename {
    if ((self = [super init])) {
        NSString *fullPath = [[[NSBundle bundleForClass:self.class] bundlePath] stringByAppendingPathComponent:filename];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];

        doc_ = xmlReadMemory([data bytes], [data length], "", nil, XML_PARSE_RECOVER);
        
        if ([self isValid]) {
            node_ = xmlDocGetRootElement(doc_);
            
            if (!node_) {
                xmlFreeDoc(doc_); doc_ = nil;
            }
        }
    }
    
    return self;    
}

- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString *)extension {
    if ((self = [super init])) {
        NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:extension];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        
        doc_ = xmlReadMemory([data bytes], [data length], "", nil, XML_PARSE_RECOVER);
        
        if ([self isValid]) {
            node_ = xmlDocGetRootElement(doc_);
            
            if (!node_) {
                xmlFreeDoc(doc_); doc_ = nil;
            }
        }
    }
    
    return self;    
}

- (id)initFromURL:(NSURL *)url {
    if ((self = [super init])) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        doc_ = xmlReadMemory([data bytes], [data length], "", nil, XML_PARSE_RECOVER);
        
        if ([self isValid]) {
            node_ = xmlDocGetRootElement(doc_);
            
            if (!node_) {
                xmlFreeDoc(doc_); doc_ = nil;
            }
        }
    }
    
    return self;    
}

- (id)initFromXMLData:(NSData *)data {
    if ((self = [super init])) {
        doc_ = xmlReadMemory([data bytes], [data length], "", nil, XML_PARSE_RECOVER);
        
        if ([self isValid]) {
            node_ = xmlDocGetRootElement(doc_);
            
            if (!node_) {
                xmlFreeDoc(doc_); doc_ = nil;
            }
        }
    }
    
    return self;    
}

- (id)initFromXMLNode:(xmlNodePtr)node {
    if ((self = [super init])) {
        doc_ = nil;
        node_ = node;
    }
    
    return self;        
}

+ (id)elementFromXMLString:(NSString *)attributeXML_ encoding:(NSStringEncoding)encoding {
    return [[[RXMLElement alloc] initFromXMLString:attributeXML_ encoding:encoding] autorelease];    
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
    if (doc_ != nil) xmlFreeDoc(doc_);
    
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

- (NSInteger)textAsInt {
    return [self.text intValue];
}

- (double)textAsDouble {
    return [self.text doubleValue];
}

- (NSString *)attribute:(NSString *)attName {
    const unsigned char *attCStr = xmlGetProp(node_, (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding]);        

    if (attCStr) {
        return [NSString stringWithUTF8String:(const char *)attCStr];
    }
    
    return nil;
}

- (NSString *)attribute:(NSString *)attName inNamespace:(NSString *)ns {
    const unsigned char *attCStr = xmlGetNsProp(node_, (const xmlChar *)[attName cStringUsingEncoding:NSUTF8StringEncoding], (const xmlChar *)[ns cStringUsingEncoding:NSUTF8StringEncoding]);

    if (attCStr) {
        return [NSString stringWithUTF8String:(const char *)attCStr];
    }
    
    return nil;
}

- (NSInteger)attributeAsInt:(NSString *)attName {
    return [[self attribute:attName] intValue];
}

- (NSInteger)attributeAsInt:(NSString *)attName inNamespace:(NSString *)ns {
    return [[self attribute:attName inNamespace:ns] intValue];
}

- (double)attributeAsDouble:(NSString *)attName {
    return [[self attribute:attName] doubleValue];
}

- (double)attributeAsDouble:(NSString *)attName inNamespace:(NSString *)ns {
    return [[self attribute:attName inNamespace:ns] doubleValue];
}

- (BOOL)isValid {
    return (doc_ != nil);
}

#pragma mark -

- (RXMLElement *)child:(NSString *)tagName {
    NSArray *components = [tagName componentsSeparatedByString:@"."];
    xmlNodePtr cur = node_;
    
    // navigate down
    for (NSString *iTagName in components) {
        const xmlChar *tagNameC = (const xmlChar *)[iTagName cStringUsingEncoding:NSUTF8StringEncoding];

        if ([iTagName isEqualToString:@"*"]) {
            cur = cur->children;
            
            while (cur != nil && cur->type != XML_ELEMENT_NODE) {
                cur = cur->next;
            }
        } else {
            cur = cur->children;
            while (cur != nil) {
                if (cur->type == XML_ELEMENT_NODE && !xmlStrcmp(cur->name, tagNameC)) {
                    break;
                }
                
                cur = cur->next;
            }
        }
        
        if (!cur) {
            break;
        }
    }
    
    if (cur) {
        return [RXMLElement elementFromXMLNode:cur];
    }
  
    return nil;
}

- (RXMLElement *)child:(NSString *)tagName inNamespace:(NSString *)ns {
    NSArray *components = [tagName componentsSeparatedByString:@"."];
    xmlNodePtr cur = node_;
    const xmlChar *namespaceC = (const xmlChar *)[ns cStringUsingEncoding:NSUTF8StringEncoding];
    
    // navigate down
    for (NSString *iTagName in components) {
        const xmlChar *tagNameC = (const xmlChar *)[iTagName cStringUsingEncoding:NSUTF8StringEncoding];
        
        if ([iTagName isEqualToString:@"*"]) {
            cur = cur->children;
            
            while (cur != nil && cur->type != XML_ELEMENT_NODE && !xmlStrcmp(cur->ns->href, namespaceC)) {
                cur = cur->next;
            }
        } else {
            cur = cur->children;
            while (cur != nil) {
                if (cur->type == XML_ELEMENT_NODE && !xmlStrcmp(cur->name, tagNameC) && !xmlStrcmp(cur->ns->href, namespaceC)) {
                    break;
                }
                
                cur = cur->next;
            }
        }
        
        if (!cur) {
            break;
        }
    }
    
    if (cur) {
        return [RXMLElement elementFromXMLNode:cur];
    }
    
    return nil;
}

- (NSArray *)children:(NSString *)tagName {
    const xmlChar *tagNameC = (const xmlChar *)[tagName cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *children = [NSMutableArray array];
    xmlNodePtr cur = node_->children;

    while (cur != nil) {
        if (cur->type == XML_ELEMENT_NODE && !xmlStrcmp(cur->name, tagNameC)) {
            [children addObject:[RXMLElement elementFromXMLNode:cur]];
        }
        
        cur = cur->next;
    }
    
    return [[children copy] autorelease];
}

- (NSArray *)children:(NSString *)tagName inNamespace:(NSString *)ns {
    const xmlChar *tagNameC = (const xmlChar *)[tagName cStringUsingEncoding:NSUTF8StringEncoding];
    const xmlChar *namespaceC = (const xmlChar *)[ns cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *children = [NSMutableArray array];
    xmlNodePtr cur = node_->children;
    
    while (cur != nil) {
        if (cur->type == XML_ELEMENT_NODE && !xmlStrcmp(cur->name, tagNameC) && !xmlStrcmp(cur->ns->href, namespaceC)) {
            [children addObject:[RXMLElement elementFromXMLNode:cur]];
        }
        
        cur = cur->next;
    }
    
    return [[children copy] autorelease];
}

- (NSArray *)childrenInXPath:(NSString *)query {
    // check for a query
    if (!query) {
        return [NSArray array];
    }

    xmlXPathContextPtr context = xmlXPathNewContext(doc_);
    
    if (context == NULL) {
		return nil;
    }
    
    xmlXPathObjectPtr object = xmlXPathEvalExpression((xmlChar *)[query cStringUsingEncoding:NSUTF8StringEncoding], context);
    if(object == NULL) {
		return nil;
    }
    
	xmlNodeSetPtr nodes = object->nodesetval;
	if (nodes == NULL) {
		return nil;
	}
    
	NSMutableArray *resultNodes = [NSMutableArray array];
    
    for (NSInteger i = 0; i < nodes->nodeNr; i++) {
		RXMLElement *element = [RXMLElement elementFromXMLNode:nodes->nodeTab[i]];
        
		if (element != NULL) {
			[resultNodes addObject:element];
		}
	}
    
    xmlXPathFreeObject(object);
    xmlXPathFreeContext(context); 
    
    return resultNodes;
}

#pragma mark -

- (void)iterate:(NSString *)query with:(void (^)(RXMLElement *))blk {
    // check for a query
    if (!query) {
        return;
    }
    
    NSArray *components = [query componentsSeparatedByString:@"."];
    xmlNodePtr cur = node_;

    // navigate down
    for (NSInteger i=0; i < components.count; ++i) {
        NSString *iTagName = [components objectAtIndex:i];
        
        if ([iTagName isEqualToString:@"*"]) {
            cur = cur->children;

            // different behavior depending on if this is the end of the query or midstream
            if (i < (components.count - 1)) {
                // midstream
                do {
                    if (cur->type == XML_ELEMENT_NODE) {
                        RXMLElement *element = [RXMLElement elementFromXMLNode:cur];
                        NSString *restOfQuery = [[components subarrayWithRange:NSMakeRange(i + 1, components.count - i - 1)] componentsJoinedByString:@"."];
                        [element iterate:restOfQuery with:blk];
                    }
                    
                    cur = cur->next;
                } while (cur != nil);
                    
            }
        } else {
            const xmlChar *tagNameC = (const xmlChar *)[iTagName cStringUsingEncoding:NSUTF8StringEncoding];

            cur = cur->children;
            while (cur != nil) {
                if (cur->type == XML_ELEMENT_NODE && !xmlStrcmp(cur->name, tagNameC)) {
                    break;
                }
                
                cur = cur->next;
            }
        }

        if (!cur) {
            break;
        }
    }

    if (cur) {
        // enumerate
        NSString *childTagName = [components lastObject];
        
        do {
            if (cur->type == XML_ELEMENT_NODE) {
                RXMLElement *element = [RXMLElement elementFromXMLNode:cur];
                blk(element);
            }
            
            if ([childTagName isEqualToString:@"*"]) {
                cur = cur->next;
            } else {
                const xmlChar *tagNameC = (const xmlChar *)[childTagName cStringUsingEncoding:NSUTF8StringEncoding];

                while ((cur = cur->next)) {
                    if (cur->type == XML_ELEMENT_NODE && !xmlStrcmp(cur->name, tagNameC)) {
                        break;
                    }                    
                }
            }
        } while (cur);
    }
}

- (void)iterateXPath:(NSString *)query with:(void (^)(RXMLElement *))blk {
    NSArray *children = [self childrenInXPath:query];
    [self iterateElements:children with:blk];
}

- (void)iterateElements:(NSArray *)elements with:(void (^)(RXMLElement *))blk {
    for (RXMLElement *iElement in elements) {
        blk(iElement);
    }
}

@end
