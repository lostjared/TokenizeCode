//
//  AppController.h
//  Tokenize-Code
//
//  Created by Jared Bruni on 8/5/16.
//  Copyright © 2016 Jared Bruni. All rights reserved.
//

#ifndef AppController_h
#define AppController_h

#include<Cocoa/Cocoa.h>
#import<WebKit/WebKit.h>

@interface AppController : NSObject {
    
    IBOutlet WebView *web_v;
    IBOutlet NSTextView *text_v;
    IBOutlet NSWindow *window_v;
}

- (IBAction) tokenizeCode:(id) sender;

//@property (retain, nonatomic) IBOutlet WebView *web_v;

@end

#endif /* AppController_h */
