//
//  ViewController.h
//  Space Facts
//
//  Created by Shafi Jami on 11/21/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactsData.h"
#import "ObjectAL.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>
#import "CvIAP.h"

@interface ViewController : CvIAP <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,
MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, RevMobAdsDelegate>{
    
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrev;
    IBOutlet UIButton *btnMore;
    IBOutlet UIButton *btnPurchaseAdFreeVersion;
    IBOutlet  UITextView *txtFact;
    IBOutlet UIImageView *background;
    NSInteger startIndex;
    NSInteger lastIndex;
    NSInteger currentIndex;
    NSInteger currentIndexForAd;
    NSInteger deltaIndex;
    FactsData * facts;
    NSNumber *lastCodeObj;
    NSMutableArray *arrBgColorCode;
    NSString *currentFact;
    OALAudioTrack* audioTrack;
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
    BOOL productIsPurchased;
}

@property (nonatomic, strong)RevMobFullscreen *fullscreen;
@property (nonatomic, strong)RevMobBannerView *banner;
@property (nonatomic, strong)RevMobBanner *bannerWindow;

//- (MTLabel *)getLabel:(CGFloat)x :(CGFloat )y :(NSString *)fontName :(CGFloat )fontSize :(NSString *)text;
-(void)setTextViewAttributes:(NSString *)fontName :(CGFloat )fontSize :(NSString *)text;
-(NSInteger)randomColorCode;
-(UIImage *)randomBgImage;
-(NSString *)nextFact;
-(NSString *)prevFact;
-(NSString *)factAtRandomIndex;
-(IBAction)onNext;
-(IBAction)onPrev;
-(IBAction)onMore;
-(IBAction)oPurchaseAdFreeVersion;

@end
