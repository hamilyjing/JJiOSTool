//
//  JJTableViewDelegate.h
//  aaa
//
//  Created by hamilyjing on 5/22/16.
//  Copyright © 2016 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JJTableViewDelegate : NSObject <UITableViewDelegate>

- (id)initWithDelegate:(id<UITableViewDelegate>)delegate
             tableView:(UITableView *)tableView
        viewController:(UIViewController *)viewController;

@end
