//
//  ViewController.m
//  Space Facts
//
//  Created by Shafi Jami on 11/21/12.
//  Copyright (c) 2012 Shafi Jami. All rights reserved.
//

#import "ViewController.h"
#import "FactsData.h"
#import "Chartboost.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "Accounts/Accounts.h"
#import "Appirater.h"
#import "CvIAP.h"
//#include "FactsIAPHelper.h"

#define MAX_FACTS       399
#define CELL_CONTENT_WIDTH 170
#define CELL_CONTENT_MARGIN 10
#define FONT_SIZE 15

#define SHARETO_FACEBOOK    0
#define SHARETO_TWITTER     1
#define Email              2
#define SMS                 3
#define Rate This App       4
#define More Free Apps      5
#define iTuneStoreLink @"https://itunes.apple.com/us/app/space-facts-explore-star-astronomy/id586591326?ls=1&mt=8"
#define Old_iTunesStoresLink @"https://itunes.apple.com/us/app/space-facts-explore-stars/id584902675?ls=1&mt=8"


@implementation ViewController

@synthesize fullscreen, banner, bannerWindow;

-(void)dealloc{
    [audioTrack stop];
    [audioTrack release];
    audioTrack = nil;
    [facts release];
    [arrBgColorCode release];
    [super dealloc];
}

- (void)loadIAPInfo {
    _products = nil;
    //[[FactsIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
//        if (success) {
//            _products = products;
//            [self.tableView reloadData];
//        }
//        [self.refreshControl endRefreshing];
 //   }];
}

- (void)registerLocalNotification{
    
    UIApplication *app = [UIApplication sharedApplication];
    
    // Remove all prior notifications
    NSArray *scheduled = [app scheduledLocalNotifications];
    if (scheduled.count)
        [app cancelAllLocalNotifications];
    
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        alarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:(86400 * 5)]; // 5 days
        alarm.timeZone = [NSTimeZone defaultTimeZone];
		alarm.repeatInterval = 4;
        alarm.hasAction = NO;
		alarm.alertBody = @"Come and check out some cool astronomy facts?";
        [app scheduleLocalNotification:alarm];
        //alarm.alertLaunchImage = @"img.png";
    }
}

- (void) preloadRevMobFullscreen{
    self.fullscreen = [[RevMobAds session] fullscreen];
    self.fullscreen.delegate = self;
    [self.fullscreen loadAd];
}
- (void)displayRevMob:(BOOL)fullScreenDisplay{
    if (!productIsPurchased){                //#if LITE_VERSION
        if (fullScreenDisplay){
            if (self.fullscreen) [self.fullscreen showAd];
        }
        else{       // banner display        
            self.bannerWindow = [[RevMobAds session] banner];
            self.bannerWindow.delegate = self;
            [self.bannerWindow loadAd];
            [self.bannerWindow showAd];
        }
    }
}

- (void) displayFullscreenAd{
    if (!productIsPurchased){
        //NSLog(@"current index for ad: %d", currentIndexForAd);
        if (currentIndexForAd % 10 == 0)
            [[Chartboost sharedChartboost] showInterstitial];
        else if (currentIndexForAd % 5 == 0)
            [self displayRevMob:YES];
    }
}

- (void)viewDidLoad
{
    [btnPurchaseAdFreeVersion setHidden:YES];
    productIsPurchased = [self itemPurchasedWithIdentifier:@"com.Reece.Spacefacts.InApp" :@"ReeceCampbel" :@selector(purchaseNotificationUpdate:)];
    
    if (!productIsPurchased){
        currentIndexForAd = 0;
        [btnPurchaseAdFreeVersion setHidden:NO];
        [self preloadRevMobFullscreen];
        [self displayRevMob:NO];
        
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        //[self loadIAPInfo];
        //[[FactsIAPHelper sharedInstance] restoreCompletedTransactions];
    }
    
    [self registerLocalNotification];
    audioTrack = [[OALAudioTrack track] retain];
    lastCodeObj = [NSNumber numberWithInt:2];       // hold code for blue background, the defalut background
    [self setTextViewAttributes:@"Arial" :FONT_SIZE :@"Space Facts"];
    arrBgColorCode = [[[NSMutableArray alloc] initWithCapacity:4] retain];
    facts = [[FactsData alloc] init];
    
    CGRect btnNextFrame, btnPrevFrame, btnMoreFrame, txtFactFrame;
    btnNextFrame = btnNext.frame;
    btnPrevFrame = btnPrev.frame;
    btnMoreFrame = btnMore.frame;
    txtFactFrame = txtFact.frame;
    
    if (IS_IPHONE && !IS_IPHONE5){
        if (IS_RETINA){
            btnNextFrame.origin = CGPointMake(btnNextFrame.origin.x, btnNextFrame.origin.y - 11.5);
            btnPrevFrame.origin = CGPointMake(btnPrevFrame.origin.x, btnPrevFrame.origin.y - 12);
            btnMoreFrame.origin = CGPointMake(btnMoreFrame.origin.x, btnMoreFrame.origin.y - 12);
            txtFactFrame.origin = CGPointMake(txtFactFrame.origin.x+3, txtFactFrame.origin.y - 13);
            txtFactFrame.size = CGSizeMake(txtFactFrame.size.width, txtFactFrame.size.height - 6);
        }
    }
    if (IS_IPAD){
        if (IS_RETINA){
            btnNextFrame.origin = CGPointMake(btnNextFrame.origin.x, btnNextFrame.origin.y + 11.5);
            btnPrevFrame.origin = CGPointMake(btnPrevFrame.origin.x+12, btnPrevFrame.origin.y + 12);
            btnMoreFrame.origin = CGPointMake(btnMoreFrame.origin.x-5, btnMoreFrame.origin.y + 12);
            txtFactFrame.origin = CGPointMake(txtFactFrame.origin.x+5, txtFactFrame.origin.y + 15);
            txtFactFrame.size = CGSizeMake(txtFactFrame.size.width-10, txtFactFrame.size.height + 0);
            btnPrevFrame.size = CGSizeMake(305, 209);
        }
    }
    
    btnNext.frame = btnNextFrame;
    btnPrev.frame = btnPrevFrame;
    btnMore.frame = btnMoreFrame;
    txtFact.frame = txtFactFrame;

    [txtFact setText:[self factAtRandomIndex]];
    [super viewDidLoad];
}

- (void)restoreTapped:(id)sender {
    //[[FactsIAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)viewWillAppear:(BOOL)animated {
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;
    
    return NO;
}

- (void) setTextViewAttributes:(NSString *)fontName :(CGFloat )fontSize :(NSString *)text
{
    //txtFact.font = [UIFont fontWithName:fontName size:fontSize];
    [txtFact setBackgroundColor:[UIColor clearColor]];
    txtFact.textAlignment = 1;
    txtFact.scrollEnabled = YES;
    txtFact.editable = NO;
    [self.view addSubview:txtFact];
}

- (NSInteger)randomColorCode{
    NSInteger code;
    NSNumber *codeObj;
    int ex = 0;
    
    do {
        ex = 0;
        code = (arc4random() % 4);
        if (code > 4) code = 4;
        
        codeObj = [NSNumber numberWithInt:code];
        if ([codeObj isEqualToNumber:lastCodeObj]){
            lastCodeObj = [NSNumber numberWithInt:-1];
            ex = 1;
        }
        else{
            for (NSNumber *c in arrBgColorCode){
                if ([c isEqualToNumber:codeObj]){
                    ex = 1;
                    break;
                }
            }
        }
        
    } while (ex == 1);
    
    [arrBgColorCode addObject:codeObj];
    if ([arrBgColorCode count] >= 4){
        lastCodeObj = [arrBgColorCode objectAtIndex:3];
        [arrBgColorCode removeAllObjects];
    }
    //NSLog(@"Current color code: %d", code);
    return code;
}

- (UIImage *)randomBgImage{
    UIImage *imgBg;
    switch ([self randomColorCode]) {
        case 0:
            imgBg = [UIImage imageNamed:@"bg_green.png"];
            if (IS_IPHONE5)
                imgBg = [UIImage imageNamed:@"bg_green568h@2x.png"];
            else if (IS_IPAD)
                imgBg = [UIImage imageNamed:@"bg_green_ipad.jpg"];
            break;
            
        case 1:
            imgBg = [UIImage imageNamed:@"bg_orange.png"];
            if (IS_IPHONE5)
                imgBg = [UIImage imageNamed:@"bg_orange568@2x.png"];
            else if (IS_IPAD)
                imgBg = [UIImage imageNamed:@"bg_orange_ipad.jpg"];
            break;

        case 2:
            imgBg = [UIImage imageNamed:@"bg_blue.png"];
            if (IS_IPHONE5)
                imgBg = [UIImage imageNamed:@"bg_blue568h@2x.png"];
            else if (IS_IPAD)
                imgBg = [UIImage imageNamed:@"bg_blue_ipad.jpg"];
            break;

        case 3:
            imgBg = [UIImage imageNamed:@"bg_purple.png"];
            if (IS_IPHONE5)
                imgBg = [UIImage imageNamed:@"bg_purple568@2x.png"];
            else if (IS_IPAD)
                imgBg = [UIImage imageNamed:@"bg_purple_ipad.jpg"];
            break;

        default:
            imgBg = nil;
            break;
    }
    return imgBg;
}

- (NSString *)nextFact{
    
    currentIndex += 1;
    [btnPrev setEnabled:YES];
    if (currentIndex >= MAX_FACTS){
        currentIndex = 0;
        startIndex = 0;
        lastIndex = deltaIndex;
    }
    
    if (currentIndex >= lastIndex)
        [btnNext setEnabled:NO];
    
    //NSLog(@"Current fact index: %d", currentIndex);
    currentFact = [facts factAtIndex:currentIndex];
    [txtFact setText:currentFact];
    return currentFact;
}

- (NSString *)prevFact{
    currentIndex -= 1;
    [btnNext setEnabled:YES];
    if (currentIndex <= startIndex) [btnPrev setEnabled:NO];
    //NSLog(@"Current fact index: %d", currentIndex);
    currentFact = [facts factAtIndex:currentIndex];
    [txtFact setText:currentFact];
    return currentFact;
}

- (void)checkForInternetConnection{
    //Device cannot send Tweet.  Show error notification
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"Please check your internet connection."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)postToFaceBook{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    [accountStore requestAccessToAccountsWithType:accountType options:dic completion:^(BOOL granted, NSError *error) {
        
        //ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
        //NSLog(@"%@, %@", account.username, account.description);
    }];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled){
                //NSLog(@"Cancelled");
            }
            else{
                //NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller setInitialText:[NSString stringWithFormat:@"\"%@\"- Download this cool free space app, - ",currentFact]];
        [controller addURL:[NSURL URLWithString:iTuneStoreLink]];
        //[controller addImage:[UIImage imageNamed:@"rocket-icon-58x58.png"]];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        NSLog(@"UnAvailable");
    }
}

- (void)postToTwittiter{
    //Check if device can send tweet
    if ([TWTweetComposeViewController canSendTweet])
    {
        //Create tweet sheet and set initial text
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        NSString *msg = [NSString stringWithFormat:@"Download this cool free space app, - "];
        [tweetSheet setInitialText:msg];
        if ([msg length] > 140)
            [tweetSheet setInitialText:[msg substringToIndex:140]];
        [tweetSheet addURL:[NSURL URLWithString:iTuneStoreLink]];
        //[tweetSheet addImage:[UIImage imageNamed:@"rocket-icon-58x58.png"]];
        
        //Show tweet sheet
        [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        //Device cannot send Tweet.  Show error notification
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Unable to Tweet"
                                  message:@"Please ensure you have at least one Twitter account setup and have internet connectivity."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //if (result != MFMailComposeResultCancelled)
        //[self checkForInternetConnection];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendEmail{
    
    NSArray *toRecipients = [NSArray arrayWithObject:@""];
	MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
    
    [mailComposer setSubject:@"Check this out..."];
    [mailComposer setToRecipients:toRecipients];
	mailComposer.mailComposeDelegate = self;
    
    NSMutableString *body = [NSMutableString string];
    NSString *msg = [NSString stringWithFormat:@"\"%@\"\t Download this cool free space app, - ",currentFact];
    [body appendString:[NSString stringWithFormat:@"\t<div>%@</div>", msg]];
    [body appendString:@"<a href=https://itunes.apple.com/us/app/space-facts-explore-star-astronomy/id586591326?ls=1&mt=8'>Sent from the 'Space Facts' app,</a>"];
    [mailComposer setMessageBody: body isHTML: YES];
    [self presentModalViewController:mailComposer animated:YES];

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

- (void)sendSMS{
    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        NSString *url = iTuneStoreLink;
        NSString *msg = [NSString stringWithFormat:@"\"%@\"Download this cool free space app, - \t%@",currentFact, url];
        
        controller.body = msg;
        controller.recipients = [NSArray arrayWithObjects:nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)rateThisApp{
    //[self checkForInternetConnection];
    [Appirater rateApp];
}

- (void)moreFreeApps{
    //[self checkForInternetConnection];
    [[Chartboost sharedChartboost] showMoreApps];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self postToFaceBook];
            break;
        case 1:
            [self postToTwittiter];
            break;
        case 2:
            [self sendEmail];
            break;
        case 3:
            [self sendSMS];
            break;
        case 4:
            [self rateThisApp];
            break;
        case 5:
            [self moreFreeApps];
            break;
            
        default:
            break;
    }
}

-(IBAction) shareAction {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share to Facebook", @"Share to Twitter",@"E-mail",@"SMS",@"Rate This App",@"More Free Apps", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (NSString *)factAtRandomIndex{
    NSInteger ndx = (arc4random() % 400);
    if (ndx > MAX_FACTS) ndx = MAX_FACTS;
    //NSLog(@"Current fact index: %d", ndx);
    
    startIndex = ndx;
    lastIndex = MAX_FACTS;
    currentIndex = startIndex;
    deltaIndex = startIndex - 1;
    currentFact = [facts factAtIndex:ndx];
    return currentFact;
}

- (void)onNext{
    if ([audioTrack playing])
        [audioTrack setPaused:YES];
    [audioTrack playFile:@"Next Button.wav"];
    if (!productIsPurchased){
        currentIndexForAd += 1;
        [self displayFullscreenAd];
    }
    
    [self nextFact];
    [background setImage:[self randomBgImage]];
    txtFact.scrollsToTop = YES;    
}

- (void)onPrev{
    if ([audioTrack playing])
        [audioTrack setPaused:YES];
    [audioTrack playFile:@"Prev Button.wav"];
    if (!productIsPurchased){
        currentIndexForAd -= 1;
        if (currentIndexForAd < 0) currentIndexForAd = 0;
        [self displayFullscreenAd];
    }
    
    [self prevFact];
    [background setImage:[self randomBgImage]];
}

- (void)onMore{
    if ([audioTrack playing])
        [audioTrack setPaused:YES];
    [audioTrack playFile:@"More Button.wav"];
    [self shareAction];
}

-(void)oPurchaseAdFreeVersion{
//    SKProduct *product = [[FactsIAPHelper sharedInstance] theProduct];//_products[0];
//    if (product != nil){
//        NSLog(@"Buying %@...", product.productIdentifier);
//        [[FactsIAPHelper sharedInstance] buyProduct:product];
//    }
    
    [self purchaseAddFreeVersion];
}

-(void)purchaseNotificationUpdate:(NSNumber *)res{

    if (res.intValue == PURCHASE_SUCCESS){
        productIsPurchased = YES;
        [self.bannerWindow hideAd];
        [btnPurchaseAdFreeVersion setHidden:YES];
    }
    else{
        productIsPurchased = NO;
        [self.bannerWindow showAd];
        [btnPurchaseAdFreeVersion setHidden:NO];
    }
}

@end
