//
//  FactsIAPHelper.m
//  Space Facts
//
//  Created by Shafi Jami on 12/4/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import "FactsIAPHelper.h"

@implementation FactsIAPHelper

+ (FactsIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static FactsIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.Reece.Spacefacts.Facts_InApp",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end