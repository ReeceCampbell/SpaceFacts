#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RevMobAdsDelegate.h"

#import "RevMobAdLink.h"
#import "RevMobBannerView.h"
#import "RevMobBanner.h"
#import "RevMobButton.h"
#import "RevMobFullscreen.h"
#import "RevMobPopup.h"


typedef enum {
    RevMobAdsTestingModeOff = 0,
    RevMobAdsTestingModeWithAds,
    RevMobAdsTestingModeWithoutAds
} RevMobAdsTestingMode;


/**
 This is the main class to start using RevMob Ads.
 You can use the standard facade methods or the alternative object orientaded version.

 */
@interface RevMobAds : NSObject {
}

@property (nonatomic, assign) id<RevMobAdsDelegate> delegate;
@property (nonatomic, assign) RevMobAdsTestingMode testingMode;

#pragma mark - Alternative use

/**
 This method is necessary to get the ads objects.
 
 It must be the first method called on the application:didFinishLaunchingWithOptions: method of the application delegate.
 
 Example of Usage:
 
     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
         [RevMobAds startSessionWithAppID:@"your RevMob ID"];
 
         self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
 
         // Override point for customization after application launch.
     }
 
 @param appID: You can collect your App ID at http://revmob.com by looking up your apps.
 */
+ (RevMobAds *)startSessionWithAppID:(NSString *)anAppId;

/**
 This method can be used to get the already initializaded sesseion of RevMobAds.
 
 @return If is called before the session initialization, this method will return nil.
 */
+ (RevMobAds *)session;

/**
 This method is useful to send us information about your environment, which facilitates we identifing what is going on.
 */
- (void) printEnvironmentInformation;

#pragma mark - Basic usage

/**
 Show a fullscreen ad.

 Example of usage:
     [[RevMobAds session] showFullscreen];
 */
- (void)showFullscreen;

/**
 Show a banner.

 Example of usage:
     [[RevMobAds session] showBanner];

 @see hideBanner
 */
- (void)showBanner;

/**
 Hide the banner that is displayed.

 Example of usage:
     [[RevMobAds session] hideBanner];

 @see showBanner
 */
- (void)hideBanner;

/**
 Show popup.

 Example of usage:
     [[RevMobAds session] showPopup];

 */
- (void)showPopup;

/**
 Open the iTunes with one advertised app.

 Example of usage:
     [[RevMobAds session] openAdLinkWithDelegate:self];

 @param adelegate:  The delegate is called when ad related events happend, see
 RevMobAdsDelegate for mode details. Can be nil;

 */
- (void)openAdLinkWithDelegate:(id<RevMobAdsDelegate>)adelegate;

/**
 With this method you can create a Local Notification Ad. The created notification will be scheduled as soon the application enter to the background.
 
 To this ad unit works properly, you MUST call the readLocalNotification: method too. Check its documentation for more details.
 
 Note: You may call this method as soon as you want, after you start the RevMob session. Just be aware that it will consume an amount of memory
 for each local notification, until the application enter to the background, where the memory will be released.
 
 Example of Usage:
 
     NSDate *today = [NSDate date];
     [[RevMobAds session] scheduleLocalNotification:[today dateByAddingTimeInterval:5]];
 
 */
- (void)scheduleLocalNotification:(NSDate *)fireDate;

/**
 This method is similar to scheduleLocalNotification:, except the RevMob will decide when to show the local notification.
 
 Example of Usage:
 
     [[RevMobAds session] scheduleLocalNotification];
 
 */
- (void)scheduleLocalNotification;

/**
 This method is responsible to read the local notification previously created by the method scheduleLocalNotification: (Check its documentation for more details).
 
 Important: You MUST call this method inside of the application:didReceiveLocalNotification: method of your application delegate (UIApplicationDelegate).
 
 Note: Do not worry about the notifications of your application, because RevMob will only process its own notifications.
 
 Example of Usage:
 
    - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
        [[RevMobAds session] processLocalNotification:notification];
    }
 
 */
- (void)processLocalNotification:(UILocalNotification *)notification;

#pragma mark - Advanced mode

/**
 This is the factory of RevMobFullscreen ad object

 Example of Usage:

     RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
     ad.delegate = self;
     [ad loadAd];
     [ad showAd];
 
 @return RevMobFullscreen object.
*/
- (RevMobFullscreen *)fullscreen;

/**
 This is the factory of RevMobFullscreen ad object

 Example of Usage:

     RevMobFullscreen *ad = [[RevMobAds session] fullscreenWithPlacementId:@"your RevMob placementId"]; // you must retain this object
     ad.delegate = self;
     [ad loadAd];
     [ad showAd];


 @param placementId: Optional parameter that identify the placement of your ad,
 you can collect your ids at http://revmob.com by looking up your apps. Can be nil.
 @return RevMobFullscreen object.
 */
- (RevMobFullscreen *)fullscreenWithPlacementId:(NSString *)placementId;

/**
 This is the factory of RevMobBannerView ad object

 Example of Usage:
 
      RevMobBannerView *ad = [[RevMobAds session] bannerView]; // you must retain this object
      ad.delegate = self;
      [ad loadAd];
      ad.frame = CGRectMake(0, 0, 320, 50);
      [self.view addSubView:ad];
 
  @return RevMobBannerView object. 
*/
- (RevMobBannerView *)bannerView;

/**
 This is the factory of RevMobBannerView ad object

 Example of Usage:

      RevMobBannerView *ad = [[RevMobAds session] bannerViewWithPlacementId:@"your RevMob placementId"]; // you must retain this object
      ad.delegate = self;
      [ad loadAd];
      ad.frame = CGRectMake(0, 0, 320, 50);
      [self.view addSubView:ad];

 @param placementId: Optional parameter that identify the placement of your ad,
 you can collect your ids at http://revmob.com by looking up your apps. Can be nil.
 @return RevMobBannerView object.
 */
- (RevMobBannerView *)bannerViewWithPlacementId:(NSString *)placementId;


/**
 This is the factory of RevMobBanner ad object

 Example of Usage:
 
      RevMobBanner *ad = [[RevMobAds session] banner]; // you must retain this object
      ad.delegate = self;
      [ad loadAd];
      [ad showAd];
 
  @return RevMobBanner object.
*/
- (RevMobBanner *)banner;

/**
 This is the factory of RevMobBanner ad object

 Example of Usage:

      RevMobBanner *ad = [[RevMobAds session] bannerWithPlacementId:@"your RevMob placementId"]; // you must retain this object
      ad.delegate = self;
      [ad loadAd];
      [ad showAd];

 @param placementId: Optional parameter that identify the placement of your ad,
 you can collect your ids at http://revmob.com by looking up your apps. Can be nil.
 @return RevMobBanner object.
 */
- (RevMobBanner *)bannerWithPlacementId:(NSString *)placementId;


/**
 This is the factory of button ad object

 Example of Usage:

       UIButton *button = [[RevMobAds session] button]; // you must retain this object
       [button setFrame:CGRectMake(0, 0, 320, 50)];
       [self.view addSubview:button];
       [button setTitle:@"Free Games" forState:UIControlStateNormal];
 
  @return RevMobButton object.
*/
- (RevMobButton *)button;

/**
 This is the factory of button ad object

 Example of Usage:

     UIButton *button = [[RevMobAds session] buttonWithPlacementId:@"your RevMob placementId"]; // you must retain this object
     [button setFrame:CGRectMake(0, 0, 320, 50)];
     [self.view addSubview:button];
     [button setTitle:@"Free Games" forState:UIControlStateNormal];

 @param placementId: Optional parameter that identify the placement of your ad,
 you can collect your ids at http://revmob.com by looking up your apps. Can be nil.
 @return RevMobButton object.
 */
- (RevMobButton *)buttonWithPlacementId:(NSString *)placementId;


/**
 This is the factory of adLink object

 Example of Usage:
 
     RevMobAdLink *ad = [[RevMobAds session] adLink]; // you must retain this object
     ad.delegate = self;
     [ad loadAd];
     [ad openLink];
 
  @return RevMobAdLink object.
*/
- (RevMobAdLink *)adLink;

/**
 This is the factory of adLink object

 Example of Usage:

      RevMobAdLink *ad = [[RevMobAds session] adLinkWithPlacementId:@"your RevMob placementId"]; // you must retain this object
      ad.delegate = self;
      [ad loadAd];
      [ad openLink];

 @param placementId: Optional parameter that identify the placement of your ad,
 you can collect your ids at http://revmob.com by looking up your apps. Can be nil.
 @return RevMobAdLink object.
 */
- (RevMobAdLink *)adLinkWithPlacementId:(NSString *)placementId;

/**
 This is the factory of popup ad object

 Example of Usage:
 
      RevMobPopup *ad = [[RevMobAds session] popup]; // you must retain this object
      ad.delegate = self;
      [ad showAd];
 
  @return RevMobPopup object.
*/
- (RevMobPopup *)popup;

/**
 This is the factory of popup ad object

 Example of Usage:

      RevMobPopup *ad = [[RevMobAds session] popupWithPlacementId:@"your RevMob placementId"]; // you must retain this object
      ad.delegate = self;
      [ad showAd];

 @param placementId: Optional parameter that identify the placement of your ad,
 you can collect your ids at http://revmob.com by looking up your apps. Can be nil.
 @return RevMobPopup object.
 */
- (RevMobPopup *)popupWithPlacementId:(NSString *)placementId;


@end
