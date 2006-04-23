//
//  CSMFileSubscription.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 9/20/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "CSMFileSubscription.h"


@implementation CSMFileSubscription

-(void)dealloc{
    [thePath release];    
    FNUnsubscribe(theSubRef);
    [super dealloc];
}

-(NSString*)path{
    return thePath;
}

+(id)createForPath:(NSString*)aPath WithCallback:(FNSubscriptionProcPtr) aCallback AndContext:(void*) aContext{
    return [[[self alloc] initForPath:aPath WithCallback:aCallback AndContext:aContext] autorelease];
}

-(id)initForPath:(NSString*)aPath WithCallback:(FNSubscriptionProcPtr) aCallback AndContext:(void*) aContext{
    if(self = [super init]){
        theFSRef:
        theSubRef = NULL;
        thePath = [aPath retain];
        NSURL* tURL =[NSURL fileURLWithPath:[self path]];
        if(tURL != nil
           &&  CFURLGetFSRef((CFURLRef)tURL,&theFSRef)){
            FNSubscribe(&theFSRef,
                        NewFNSubscriptionUPP(aCallback),
                        aContext,
                        kNilOptions,
                        &theSubRef); 
        }
    }return self;
}



@end
