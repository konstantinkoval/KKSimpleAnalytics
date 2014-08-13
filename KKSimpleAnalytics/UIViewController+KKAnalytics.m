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
ASSOCIATED(trackers, setTrackers, NSArray*, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
ASSOCIATED(analyticsDelegate, setAnalyticsDelegate, id<ViewAnalyticsDelegate>, OBJC_ASSOCIATION_ASSIGN)

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

- (id<GAITracker>)activeTracker {
  return self.tracker ? self.tracker : [[GAI sharedInstance] defaultTracker];
}

- (NSArray *)activeTrackers {
  
  if(self.trackers) {
    return self.trackers;
  } else {
    return @[[self activeTracker]];
  }

}

- (void)trackPageView:(NSString *)screenName {
  
  NSArray *trackes = [self activeTrackers];
  for (id<GAITracker> tracker in trackes) {
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
  }
  
  id<ViewAnalyticsDelegate> delegate = self.analyticsDelegate;
  if (delegate && [delegate respondsToSelector:@selector(didTrackPageView:)]) {
    [delegate didTrackPageView:screenName];
  }
}

- (void)kkk_viewDidAppear:(BOOL)animated
{
    if (self.screenName) {
        [self trackPageView:self.screenName];
    }
    [self kkk_viewDidAppear:animated];
}

@end
