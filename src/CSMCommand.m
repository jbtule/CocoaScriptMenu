/* ***** BEGIN LICENSE BLOCK *****
* Version: MPL 1.1/GPL 2.0/LGPL 2.1
*
* The contents of this file are subject to the Mozilla Public License Version
* 1.1 (the "License"); you may not use this file except in compliance with
* the License. You may obtain a copy of the License at
* http://www.mozilla.org/MPL/
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the
* License.
*
* The Original Code is CocoaScriptMenu.
*
* The Initial Developer of the Original Code is
* James Tuley.
* Portions created by the Initial Developer are Copyright (C) 2004-2005
* the Initial Developer. All Rights Reserved.
*
* Contributor(s):
*           James Tuley <jbtule@mac.com> (Original Author)
*
* Alternatively, the contents of this file may be used under the terms of
* either the GNU General Public License Version 2 or later (the "GPL"), or
* the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
* in which case the provisions of the GPL or the LGPL are applicable instead
* of those above. If you wish to allow use of your version of this file only
* under the terms of either the GPL or the LGPL, and not to allow others to
* use your version of this file under the terms of the MPL, indicate your
* decision by deleting the provisions above and replace them with the notice
* and other provisions required by the GPL or the LGPL. If you do not delete
* the provisions above, a recipient may use your version of this file under
* the terms of any one of the MPL, the GPL or the LGPL.
*
* ***** END LICENSE BLOCK ***** */

//
//  CSMCommand.m
//  CocoaScriptMenu
//
//  Created by James Tuley on 9/18/05.
//  Copyright 2005 James Tuley. All rights reserved.
//

#import "CSMCommand.h"
#import "CSMCommandPrivate.h"
#import "CSMWorkflowCommand.h"
#import "CSMExecutableCommand.h"
#import "CSMShellScriptCommand.h"
#import "CSMFolderCommand.h"
#import "CSMAppleScriptCommand.h"
#import "CSMPlainOpenCommand.h"
#import "CSMPlaceholderCommand.h"
#import "NSString-UTIAdditions.h"
#import "CSMMenuNameParser.h"
#import "TenThreeCompatibility.h"




@implementation CSMCommand


- (void)dealloc {
    [theNameParser release];
    [theFilePath release];
    [super dealloc];
}

+(id)commandWithScriptPath:(NSString*) aPath{
    return [[[self alloc] initWithScriptPath:aPath] autorelease];
}

+(id)alloc{
    static CSMCommand* theCommandPlaceHolder = nil;
    if(theCommandPlaceHolder == nil){
        theCommandPlaceHolder =[[CSMPlaceholderCommand alloc] init];
    }
    return theCommandPlaceHolder;
}


-(id)initWithScriptPath:(NSString*) aPath{
    theNameParser= nil;
    NSString* tWorkflowExt = @"workflow";
    NSString* tUTTypeWorkflow = 
        [(NSString*)TTCTypeCreatePreferredIdentifierForTag(
                                              kUTTagClassFilenameExtension,
                                               (CFStringRef)tWorkflowExt,
                                              NULL) autorelease];
  
    NSString* tUTI = [aPath UTIForPath];
    if([tUTI conformsToUTI:@"com.apple.applescript.text"] 
             || [tUTI conformsToUTI:@"com.apple.applescript.script"]){
       return [[CSMAppleScriptCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:@"public.shell-script"]){
        return  [[CSMShellScriptCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:TTCConstantIfAvailible((void**)&kUTTypeApplication,@"com.apple.application ")]){
        return [[CSMExecutableCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:tUTTypeWorkflow]){
        return [[CSMWorkflowCommand alloc] initWithScriptPath:aPath];
    }else if([tUTI conformsToUTI:TTCConstantIfAvailible((void**)&kUTTypeFolder,@"public.folder")]){
        return [[CSMFolderCommand alloc] initWithScriptPath:aPath];
    }else{
        NSLog(@"Unknown Script %@ | %@",aPath, [aPath UTIForPath]);
        return [[CSMPlainOpenCommand alloc] initWithScriptPath:aPath];
    }
}

-(NSString*)menuName{
    return [theNameParser name];
}

-(NSString*)filePath{
    return theFilePath;
}

-(NSString*)sortName{
    return [theNameParser sortName];
}

-(NSComparisonResult)compare:(CSMCommand *)aCommand{
    return [[self sortName] compare:[theNameParser sortName]];
}

-(IBAction)executeScript:(id)sender{
    [self CSM_executeOperation];
}

-(BOOL)isMenuDivider{
   return [[self menuName] isEqualToString:@"-"];
}

-(NSMenuItem*)menuItem{
    if([self isMenuDivider]){
        return (NSMenuItem*)[NSMenuItem separatorItem];
    }
    
    return [self CSM_menuItem];
}

@end

