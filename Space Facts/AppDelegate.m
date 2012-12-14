//
//  AppDelegate.m
//  Space Facts
//
//  Created by Shafi Jami on 11/21/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Chartboost.h"
#import "Appirater.h"
#import <RevMobAds/RevMobAds.h>
#import "CvIAP.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
    // Initialize Chartboost
    Chartboost *cb = [Chartboost sharedChartboost];
    
    /*
     * Add your own app id & signature. These can be found on App Edit page for your app in the Chartboost dashboard
     *
     * Notes:
     * 1) BE SURE YOU USE YOUR OWN CORRECT APP ID & SIGNATURE!
     * 2) We cant help if it is missing or incorrect in a live app. You will have to resubmit.
     */
    
    cb.appId = @"50b3dbf117ba47c229000000";
    cb.appSignature = @"9bc045df45338835cb243f4e11792be4883b6ec9";   
    cb.delegate = self;
    
    // Begin a user session. This should be done once per boot
    [cb startSession];
    
    // Cache an interstitial at the default location
    [cb cacheInterstitial];
    
    // Cache an interstitial at some named locations -- (Pro Tip: do this!)
    [cb cacheInterstitial:@"After level 1"];
    [cb cacheInterstitial:@"Pause screen"];
    
    /*
     * Once cached, use showInterstitial to display the interstitial immediately like this:
     *
     * [cb showInterstitial:@"After level 1"];
     *
     * Notes:
     * 1) Each named location has it's own cache, only one interstitial is stored per named location
     * 2) Cached interstitials are deleted as soon as they're shown
     * 3) If no interstitial is cached for that location, showInterstitial will load one on the fly from Chartboost
     *
     * Pro Tip: Implement didDismissInterstitial to immediately re-cache interstitials by location (see below)
     *
     */
    
    // Cache the more apps page so it's loaded & ready
    [cb cacheMoreApps];
}

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    
    [[Chartboost sharedChartboost] cacheMoreApps];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"586591326"];
    [Appirater setDaysUntilPrompt:0];
    [Appirater setUsesUntilPrompt:0];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    //[Appirater setDebug:YES];
    
    if (![[CvIAP sharedInstance] itemPurchasedWithIdentifier:@"com.Reece.Spacefacts.InApp" :@"ReeceCampbel" :@selector(purchaseNotificationUpdate:)])
        [RevMobAds startSessionWithAppID:REVMOB_ID];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if (IS_IPHONE5)
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone5" bundle:nil] autorelease];
    else if (IS_IPHONE || IS_IPOD)
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    else
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[RevMobAds session] processLocalNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
