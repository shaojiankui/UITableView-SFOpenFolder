//
//  AppDelegate.h
//  UITableView-SFOpenFolder
//
//  Created by Jakey on 2017/3/31.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
@class TableViewViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TableViewViewController *rootViewController;
@property (strong, nonatomic) UINavigationController *navgationController;
+(AppDelegate*)APP;
@end

