// ================================================================================================
//  RaptureXMLAppDelegate.m
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
