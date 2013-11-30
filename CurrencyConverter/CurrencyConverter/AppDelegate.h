//
//  AppDelegate.h
//  CurrencyConverter
//
//  Created by Nandini  Sundara Raman on 11/26/13.
//  Copyright (c) 2013 Nandini Sundara Raman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGuidedAccessRestrictions.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIGuidedAccessRestrictionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *arrayToControl;

@end
