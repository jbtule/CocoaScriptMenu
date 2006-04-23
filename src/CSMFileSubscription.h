//
//  CSMFileSubscription.h
//  CocoaScriptMenu
//
//  Created by James Tuley on 9/20/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CSMFileSubscription : NSObject {
    @protected
    NSString* thePath;
    FSRef theFSRef;
    FNSubscriptionRef theSubRef;
}
                        
+(id)createForPath:(NSString*)aPath WithCallback:(FNSubscriptionProcPtr) aCallback AndContext:(void*) aContext;

-(id)initForPath:(NSString*)aPath WithCallback:(FNSubscriptionProcPtr) aCallback AndContext:(void*) aContext;

-(NSString*)path;

@end
