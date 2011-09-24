//
//  RXMLElement.h
//  RaptureXML
//
//  Created by John Blanco on 9/23/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface RXMLElement : NSObject {
    TBXML *xml_;
    TBXMLElement *tbxmlElement_;
}

- (id)initFromXMLString:(NSString *)xmlString;
- (id)initFromXMLFile:(NSString *)filename;
- (id)initFromXMLFile:(NSString *)filename fileExtension:(NSString*)extension;
- (id)initFromURL:(NSURL *)url;
- (id)initFromXMLData:(NSData *)data;
- (id)initFromTBXMLElement:(TBXMLElement *)tbxmlElement;

+ (id)elementFromXMLString:(NSString *)filename;
+ (id)elementFromXMLFile:(NSString *)filename;
+ (id)elementFromXMLFilename:(NSString *)filename fileExtension:(NSString *)extension;
+ (id)elementFromURL:(NSURL *)url;
+ (id)elementFromXMLData:(NSData *)data;
+ (id)elementFromTBXMLElement:(TBXMLElement *)tbxmlElement;

- (NSString *)attribute:(NSString *)attName;

- (RXMLElement *)child:(NSString *)tagName;
- (NSArray *)children:(NSString *)tagName;

- (void)iterate:(NSString *)query with:(void (^)(RXMLElement *))blk;
- (void)iterateElements:(NSArray *)elements with:(void (^)(RXMLElement *))blk;

@property (nonatomic, readonly) NSString *tag;
@property (nonatomic, readonly) NSString *text;

@end

typedef void (^RXMLBlock)(RXMLElement *);

