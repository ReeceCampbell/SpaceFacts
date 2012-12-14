//
//  FactsData.m
//  Space Facts
//
//  Created by Shafi Jami on 11/21/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import "FactsData.h"

@implementation FactsData

-(id)init{
    self = [super init];
    if (self){
        [self loadArrayOfFacts];
    }
    return self;
}

-(NSString *) factAtIndex:(NSInteger)index{
    if (!arrFacts) return nil;
    if (index >= [arrFacts count]) return @"";
    return [arrFacts objectAtIndex:index];
}

-(void)loadArrayOfFacts{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Facts" ofType:@"csv"];
    NSString *facts = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil ];
    arrFacts =[facts componentsSeparatedByString:@"\r\n"];
    [arrFacts retain];
    
//    for (int i =0; i< [arrFacts count]; i++){
//        NSLog(@"+++++++++ %d",i+1);
//        NSLog(@"%@",[arrFacts objectAtIndex:i]);
//    }

}

@end
