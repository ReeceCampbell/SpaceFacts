//
//  CvIAP.m
//  Space Facts
//
//  Created by Shafi Jami on 12/9/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import "CvIAP.h"
#import "SFHFKeychainUtils.h"

@implementation CvIAP

#define kStoredData @"com.emirbytes.IAPNoobService"
#define kProductIdentifier @"com.emirbytes.IAPNoobService"

@synthesize userName = _userName;
@synthesize productIdentifier = _productIdentifier;
@synthesize notificationSelector = _notificationSelector;


+ (CvIAP *)sharedInstance {
//    static dispatch_once_t once;
    static CvIAP * sharedInstance;
//    dispatch_once(&once, ^{
//        NSSet * productIdentifiers = [NSSet setWithObjects:
//                                      @"com.Reece.Spacefacts.Facts_InApp",
//                                      nil];
//        sharedInstance = [[self alloc] initWithProductIdentifier:productIdentifiers];
//    );
//    }
    
    sharedInstance = [[self alloc] init];
    return sharedInstance;
}

-(BOOL)itemPurchasedWithIdentifier:(NSString *)productIdentifier :(NSString *)userName :(SEL)notificationSelector{
    
    BOOL res = NO;
    self.userName = userName;
    self.productIdentifier = productIdentifier;
    self.notificationSelector = notificationSelector;
    res = [self IAPItemPurchased];
    
//    if (res)
//        NSLog(@"Previously purchased: %@", productIdentifier);
//    else
//        NSLog(@"Not purchased: %@", productIdentifier);
    
    return res;

}

-(BOOL)IAPItemPurchased {
    NSError *error = nil;
    NSString *pwd = [NSString stringWithFormat:@"SpaceFacts_%@", _userName];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:_userName andServiceName:kStoredData error:&error];
    
    if ([password isEqualToString:pwd]) return YES; else return NO;
    
}

-(BOOL)purchaseAddFreeVersion{
    
    if ([self IAPItemPurchased]) {
        //NSLog(@"Previously purchased: %@", self.productIdentifier);
        return ALREADY_PURCHASED;
    } else {
        confirmPurchaseAlert = [[UIAlertView alloc]
                         initWithTitle:@"remove ads"
                         message:@"Do you want to remove ads?"
                         delegate:self
                         cancelButtonTitle:nil
                         otherButtonTitles:@"Yes", @"No", nil];
        confirmPurchaseAlert.delegate = self;
        [confirmPurchaseAlert show];
        [confirmPurchaseAlert release];
    }
    
    return NOT_PURCHASED;
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    NSInteger res;
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                // show wait view here
                //NSLog(@"Processing...");
                res = PURCHASE_PROCESSING;
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                res = PURCHASE_SUCCESS;
                //NSLog(@"Done...");
                
                NSError *error = nil;
                NSString *pwd = [NSString stringWithFormat:@"SpaceFacts_%@", _userName];
                [SFHFKeychainUtils storeUsername:self.userName andPassword:pwd forServiceName:kStoredData updateExisting:YES error:&error];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                res = PURCHASE_RESTORED;
                break;
                
            case SKPaymentTransactionStateFailed:
                res = PURCHASE_CANCELLED;
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    //NSLog(@"Error payment cancelled");
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //NSLog(@"Purchase Error!");
                break;
                
            default:
                break;
        }
        
        if ([self respondsToSelector:self.notificationSelector])
            [self performSelector:self.notificationSelector withObject: [NSNumber numberWithInt:res]];

    }
}






-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    
    if (count>0) {
        validProduct = [response.products objectAtIndex:0];
        
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:self.productIdentifier];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
        [tmp release];
    }
    
    
}

-(void)requestDidFinish:(SKRequest *)request
{
    [request release];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
}



#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView==confirmPurchaseAlert) {
        if (buttonIndex==0) {
            // user tapped YES, but we need to check if IAP is enabled or not.
            if ([SKPaymentQueue canMakePayments]) {
                
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productIdentifier]];
                
                request.delegate = self;
                [request start];
                
                
            } else {
                UIAlertView *tmp = [[UIAlertView alloc]
                                    initWithTitle:@"Prohibited"
                                    message:@"Parental Control is enabled, cannot make a purchase!"
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Ok", nil];
                [tmp show];
                [tmp release];
            }
        }
    }
    
}

@end
