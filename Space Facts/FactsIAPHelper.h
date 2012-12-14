//
//  FactsIAPHelper.h
//  Space Facts
//
//  Created by Shafi Jami on 12/4/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import "IAPHelper.h"

@interface FactsIAPHelper : IAPHelper

//- (SKProduct *)getProduct;
+ (FactsIAPHelper *)sharedInstance;

@end