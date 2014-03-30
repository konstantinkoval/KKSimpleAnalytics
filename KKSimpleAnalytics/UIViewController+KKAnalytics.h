//
//  UIViewController+KKAnalytics.h
//  KKSimpleAnalytics
//
//  Created by Konstantin Koval on 30/03/14.
//  Copyright (c) 2014 Konstantin Koval. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GAITracker;

@interface UIViewController (KKAnalytics)

@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, assign) id<GAITracker> tracker;

@end
