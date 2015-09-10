//
//  AppDelegate.m
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Typhoon.h>
#import <Wit/Wit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "DefaultAssembly.h"
#import "TyphoonComponents.h"
#import "FoodHero-Swift.h"
#import "WitSpeechRecognitionService.h"
#import "ConversationAppService.h"
#import "ConversationViewController.h"
#import "ConversationViewController+ViewDimensionCalculator.h"

@implementation AppDelegate {
    bool _applicationDidFinishLaunching;
    TyphoonStoryboard *_storyboard;
    id <ApplicationAssembly> _assembly;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Google Map
    [GMSServices provideAPIKey:@"AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg"];

    [TyphoonComponents configure:[DefaultAssembly assembly]];
    _storyboard = [TyphoonComponents storyboard];
    _assembly =  (id <ApplicationAssembly>) [_storyboard factory];

    self.window.rootViewController = [_storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];

    // Google Analytics
    [GAIService configure:^() {
        [self configureUserNotification:application];
    }];

    _applicationDidFinishLaunching = true;

    return YES;
}

- (void)configureUserNotification:(const UIApplication *)application {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings]; // this will trigger didRegisterForRemoteNotificationsWithDeviceToken
}

-(void)application :(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [_assembly.conversationAppService startConversation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [WitSpeechRecognitionService sendToGAI];
    [GAIService dispatch];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
    [ConversationViewController applicationDidChangeStatusBarFrame:oldStatusBarFrame];
    if (_applicationDidFinishLaunching) {
        id <ApplicationAssembly> assembly = [TyphoonComponents getAssembly];
        ConversationViewController *cvc = [assembly conversationViewController];
        [cvc redrawCurrentViewState];
    }
}

@end
