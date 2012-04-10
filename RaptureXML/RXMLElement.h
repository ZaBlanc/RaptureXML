// ================================================================================================
//  RXMLElement.h
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

#import <Foundation/Foundation.h>
#import <libxml2/libxml/xmlreader.h>
#import <libxml2/libxml/xmlmemory.h>

@class RXMLElement;

typedef void (^RXMLBlock)(RXMLElement *element);

@interface RXMLElement : NSObject 

- (id)initWithString:(NSString *)xmlString encoding:(NSStringEncoding)encoding;
- (id)initWithFilepath:(NSString *)filename;
- (id)initWithFilename:(NSString *)filename extension:(NSString *)extension;
- (id)initWithURL:(NSURL *)url;
- (id)initWithData:(NSData *)data;
- (id)initWithNode:(xmlNodePtr)node;

+ (id)elementWithString:(NSString *)xmlString encoding:(NSStringEncoding)encoding;
+ (id)elementWithFilepath:(NSString *)filename;
+ (id)elementWithFilename:(NSString *)filename extension:(NSString *)extension;
+ (id)elementWithURL:(NSURL *)url;
+ (id)elementWithData:(NSData *)data;
+ (id)elementWithNode:(xmlNodePtr)node;

- (NSString *)attribute:(NSString *)attributeName;
- (NSString *)attribute:(NSString *)attributeName inNamespace:(NSString *)xmlNamespace;

- (NSInteger)attributeAsInteger:(NSString *)attributeName;
- (NSInteger)attributeAsInteger:(NSString *)attributeName inNamespace:(NSString *)xmlNamespace;

- (double)attributeAsDouble:(NSString *)attributeName;
- (double)attributeAsDouble:(NSString *)attributeName inNamespace:(NSString *)xmlNamespace;

- (RXMLElement *)childWithTagName:(NSString *)tagName;
- (RXMLElement *)childWithTagName:(NSString *)tagName inNamespace:(NSString *)xmlNamespace;

- (NSArray *)childrenWithTagName:(NSString *)tagName;
- (NSArray *)childrenWithTagName:(NSString *)tagName inNamespace:(NSString *)xmlNamespace;

- (void)iteratePath:(NSString *)path usingBlock:(RXMLBlock)block;
- (void)iterateElements:(NSArray *)elements usingBlock:(RXMLBlock)block;

@property (nonatomic, readonly) NSString *tag;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSInteger textAsInteger;
@property (nonatomic, readonly) double textAsDouble;
@property (nonatomic, readonly, getter = isValid) BOOL valid;

@end
