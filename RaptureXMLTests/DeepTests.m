//
//  DeepTests.m
//  RaptureXML
//
//  Created by John Blanco on 9/24/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "RXMLElement.h"

@interface DeepTests : SenTestCase {
}

@end



@implementation DeepTests

- (void)testQuery {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    __block NSInteger i;
    
    // count the players
    i = 0;
    
    [rxml iterate:@"players.player" with: ^(RXMLElement *e) {
        i++;
    }];    
    
    STAssertEquals(i, 9, nil);

    // count the first players' names
    i = 0;
    
    [rxml iterate:@"players.player.name" with: ^(RXMLElement *e) {
        i++;
    }];    
    
    STAssertEquals(i, 1, nil);

    // count the coaches
    i = 0;
    
    [rxml iterate:@"players.coach" with: ^(RXMLElement *e) {
        i++;
    }];    
    
    STAssertEquals(i, 1, nil);
}

@end
