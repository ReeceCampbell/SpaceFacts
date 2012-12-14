//
//  CvIAP.h
//  Space Facts
//
//  Created by Shafi Jami on 12/9/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

enum{
    NOT_PURCHASED = 0,
    ALREADY_PURCHASED,
    PURCHASE_PROCESSING,
    PURCHASE_SUCCESS,
    PURCHASE_RESTORED,
    PURCHASE_CANCELLED
}PURCHASE_RES;

@interface CvIAP : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>{

    UIAlertView *confirmPurchaseAlert;
    NSString *_userName;
    SEL _notificationSelector;
    NSString *_productIdentifier;
}

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, assign) SEL notificationSelector;

+(CvIAP *)sharedInstance;
-(BOOL)itemPurchasedWithIdentifier:(NSString *)productIdentifier :(NSString *)userName :(SEL)notificationSelector;
-(BOOL)IAPItemPurchased;
-(BOOL)purchaseAddFreeVersion;


@end
