//
//  RaptureXMLAppDelegate.m
//  RaptureXML
//
//  Created by John Blanco on 9/21/11.
//  Copyright 2011 Rapture In Venice. All rights reserved.
//

#import "RaptureXMLAppDelegate.h"
#import "RXMLElement.h"

@implementation RaptureXMLAppDelegate

@synthesize window = _window;

- (void)doOldWay {
    TBXML *tbxml = [TBXML tbxmlWithXMLFile:@"players.xml"];    
    TBXMLElement *rootElement = tbxml.rootXMLElement;
    
    TBXMLElement *playersElement = [TBXML childElementNamed:@"players" parentElement:rootElement];
    TBXMLElement *playerElement = [TBXML childElementNamed:@"player" parentElement:playersElement];
    
    while (playerElement) {
        TBXMLElement *nameElement = [TBXML childElementNamed:@"name" parentElement:playerElement];
        TBXMLElement *positionElement = [TBXML childElementNamed:@"position" parentElement:playerElement];
        
        NSString *number = [TBXML valueOfAttributeNamed:@"number" forElement:playerElement];
        NSString *name = [TBXML textForElement:nameElement];
        NSString *position = [TBXML textForElement:positionElement];
        
        NSLog(@"Player #%@: %@ (%@)", number, name, position);

        playerElement = [TBXML nextSiblingNamed:@"player" searchFromElement: playerElement];                
    }    
}

- (void)doNewWayWithChildren {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    RXMLElement *players = [rxml child:@"players"];
    NSArray *player = [players children:@"player"];
    
    [rxml iterateElements:player with: ^(RXMLElement *e) {
        NSLog(@"Player #%@: %@ (%@)", [e attribute:@"number"], [e child:@"name"], [e child:@"position"]);
    }];    
}

- (void)doNewWay {
    RXMLElement *rxml = [RXMLElement elementFromXMLFile:@"players.xml"];
    
    [rxml iterate:@"players.player" with: ^(RXMLElement *e) {
        NSLog(@"Player #%@: %@ (%@)", [e attribute:@"number"], [e child:@"name"], [e child:@"position"]);
    }];    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];

    [self doNewWay];
    
    return YES;
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
