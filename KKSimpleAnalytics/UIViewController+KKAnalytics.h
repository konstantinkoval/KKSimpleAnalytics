//
//  UIViewController+KKAnalytics.h
//  KKSimpleAnalytics
//
//  Created by Konstantin Koval on 30/03/14.
//  Copyright (c) 2014 Konstantin Koval. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GAITracker;

@protocol ViewAnalyticsDelegate <NSObject>

- (void)didTrackPageView:(NSString *)screenName;

@end

@interface UIViewController (KKAnalytics)

@property (nonatomic, strong) NSString *screenName;

/**
 *  Tracker for sending analytics. If it's nil, than default tracker is used
 */
@property (nonatomic, assign) id<GAITracker> tracker;

/**
 * Array of tracker. If not nil that tracker is ignored. Events and screen will be send to every tracker in that array
 */
@property (nonatomic, strong) NSArray *trackers;

/**
 *  Delegate is called to give ability to add custom logic
 */
@property (nonatomic, assign) id<ViewAnalyticsDelegate> analyticsDelegate;


@end
