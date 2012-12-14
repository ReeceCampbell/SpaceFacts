//
//  FactsData.h
//  Space Facts
//
//  Created by Shafi Jami on 11/21/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactsData : NSObject{
    
    NSArray *arrFacts;
}

-(id)init;
-(NSString *) factAtIndex:(NSInteger)index;
-(void)loadArrayOfFacts;

@end
