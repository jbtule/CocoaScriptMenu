//
//  CSMBaseCommand.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 3/25/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "CSMBaseCommand.h"
#import "CSMMenuNameParser.h"


@implementation CSMBaseCommand

+(id)alloc{
    return [[super superclass] alloc];
}

-(id)initWithScriptPath:(NSString*) aPath{
    if(self = [super init]){
        theFilePath = [[aPath stringByStandardizingPath] retain];
        theNameParser = [[[[self superclass] menuNameParser] alloc] initWithPath:theFilePath];
    }return self;
}



@end
