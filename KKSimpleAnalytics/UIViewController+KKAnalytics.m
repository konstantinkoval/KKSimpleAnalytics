//
//  UIViewController+KKAnalytics.m
//  KKSimpleAnalytics
//
//  Created by Konstantin Koval on 30/03/14.
//  Copyright (c) 2014 Konstantin Koval. All rights reserved.
//

#import "UIViewController+KKAnalytics.h"
#import "KKNSObject+Associated.h"
#import <JRSwizzle.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

@implementation UIViewController (KKAnalytics)
ASSOCIATED(screenName, setScreenName, NSString*, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
ASSOCIATED(tracker, setTracker, id<GAITracker>, OBJC_ASSOCIATION_ASSIGN)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error;
        [UIViewController jr_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(kkk_viewDidAppear:) error:&error];
        if (error) {
            NSLog(@"Can't swizzle method");
        }
    });
}

- (id<GAITracker>)activeTracker
{
    return self.tracker ? self.tracker : [[GAI sharedInstance] defaultTracker];
}

- (void)trackPageView:(NSString *)screenName
{
    id tracker = [self activeTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)kkk_viewDidAppear:(BOOL)animated
{
    if (self.screenName) {
        [self trackPageView:self.screenName];
    }
    [self kkk_viewDidAppear:animated];
}

@end
