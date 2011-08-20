//
//  HTMLParser.m
//  HNReader
//
//  Created by slim on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTMLParser.h"
#import "XMLDocument.h"
#import "XMLElement.h"
#import "NSString+Tags.h"


@interface HTMLParser()
@property(retain, nonatomic) NSString * _htmlStr;

- (NSDictionary *)parseSubmissionWithElements:(NSArray *)elements ;
@end

@implementation HTMLParser
@synthesize _htmlStr;

-(void) dealloc
{

    [_htmlStr release];
    [super dealloc];
}
-(id) initWithString:(NSString*) data
{
    self = [super init];
    if(self)
    {
        self._htmlStr = data;
    }
    return self;
}

-(NSMutableDictionary*) parsePosts
{

    XMLDocument *document = [[XMLDocument alloc] initWithHTMLData:[_htmlStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *submissions = [document elementsMatchingPath:@"//table//tr[position()>1]//td//table//tr"];
    
    // Token for the next page of items.
    NSString *more = nil;
    
    // Three rows are used per submission.
    for (int i = 0; i + 2 < [submissions count]; i += 3) {
        XMLElement *first = [submissions objectAtIndex:i];
        XMLElement *second = [submissions objectAtIndex:i + 1];
        XMLElement *third = [submissions objectAtIndex:i + 2];
        
        NSDictionary *submission = [self parseSubmissionWithElements:[NSArray arrayWithObjects:first, second, third, nil]];
        if (submission != nil) [result addObject:submission];
    }
    
    [document release];
    
    NSMutableDictionary *item = [NSMutableDictionary dictionary];
    [item setObject:result forKey:@"posts"];
    if (more != nil) [item setObject:more forKey:@"more"];
    return item;
}

- (NSDictionary *)parseSubmissionWithElements:(NSArray *)elements {
    XMLElement *first = [elements objectAtIndex:0];
    XMLElement *second = [elements objectAtIndex:1];
    XMLElement *fourth = nil;
    if ([elements count] >= 4) fourth = [elements objectAtIndex:3];
    
    // These have a number of edge cases (e.g. "discuss"),
    // so use sane default values in case of one of those.
    NSNumber *points = [NSNumber numberWithInt:0];
    NSNumber *comments = [NSNumber numberWithInt:0];
    
    NSString *title = nil;
    NSString *user = nil;
    NSNumber *identifier = nil;
    NSString *body = nil;
    NSString *date = nil;
    NSString *href = nil;
    
    for (XMLElement *element in [first children]) {
        if ([[element attributeWithName:@"class"] isEqual:@"title"]) {
            for (XMLElement *element2 in [element children]) {
                if ([[element2 tagName] isEqual:@"a"] && ![[element2 content] isEqual:@"scribd"]) {
                    title = [element2 content];
                    href = [element2 attributeWithName:@"href"];
                    
                    // In "ask HN" posts, we need to extract the id (and fix the URL) here.
                    if ([href hasPrefix:@"item?id="]) {
                        identifier = [NSNumber numberWithInt:[[href substringFromIndex:[@"item?id=" length]] intValue]];
                        href = nil;
                    }
                }
            }
        }
    }
    
    for (XMLElement *element in [second children]) {
        if ([[element attributeWithName:@"class"] isEqual:@"subtext"]) {
            NSString *content = [element content];
            
            // XXX: is there any better way of doing this?
            int start = [content rangeOfString:@"</a> "].location;
            if (start != NSNotFound) content = [content substringFromIndex:start + [@"</a> " length]];
            int end = [content rangeOfString:@" ago"].location;
            if (end != NSNotFound) date = [content substringToIndex:end];
            
            for (XMLElement *element2 in [element children]) {
                NSString *content = [element2 content];
                NSString *tag = [element2 tagName];
                
                if ([tag isEqual:@"a"]) {
                    if ([[element2 attributeWithName:@"href"] hasPrefix:@"user?id="]) {
                        user = [content stringByRemovingHTMLTags];
                        user = [user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    } else if ([[element2 attributeWithName:@"href"] hasPrefix:@"item?id="]) {
                        int end = [content rangeOfString:@" "].location;
                        if (end != NSNotFound) comments = [NSNumber numberWithInt:[[content substringToIndex:end] intValue]];
                        
                        identifier = [NSNumber numberWithInt:[[[element2 attributeWithName:@"href"] substringFromIndex:[@"item?id=" length]] intValue]];
                    }
                } else if ([tag isEqual:@"span"]) {
                    int end = [content rangeOfString:@" "].location;
                    if (end != NSNotFound) points = [NSNumber numberWithInt:[[content substringToIndex:end] intValue]];
                }
            }
        } else if ([[element attributeWithName:@"class"] isEqual:@"title"] && [[element content] isEqual:@"More"]) {
            // XXX: parse more link: [[element attributeWithName:@"href"] substringFromIndex:[@"x?fnid=" length]];
        }
    }
    
    for (XMLElement *element in [fourth children]) {
        if ([[element tagName] isEqual:@"td"]) {
            BOOL isReplyForm = NO;
            NSString *content = [element content];
            
            for (XMLElement *element2 in [element children]) {
                if ([[element2 tagName] isEqual:@"form"]) {
                    isReplyForm = YES;
                    break;
                }
            }
            
            if ([content length] > 0 && !isReplyForm) {
                body = content;
            }
        }
    }
    
    // XXX: better sanity checks?
    if (user != nil && title != nil && identifier != nil) {
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setObject:user forKey:@"user"];
        [item setObject:points forKey:@"points"];
        [item setObject:title forKey:@"title"];
        [item setObject:comments forKey:@"numchildren"];
        if (href != nil) [item setObject:href forKey:@"url"];
        [item setObject:date forKey:@"date"];
        if (body != nil) [item setObject:body forKey:@"body"];
        [item setObject:identifier forKey:@"identifier"];
        return item;
    } else {
        NSLog(@"Bug: Ignoring unparsable submission (more link?).");
        return nil;
    }
}

@end
