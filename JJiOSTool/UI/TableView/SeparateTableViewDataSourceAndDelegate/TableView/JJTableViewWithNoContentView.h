//
//  JJTableViewWithNoContentView.h
//  clientUI
//
//  Created by Gong Jian on 14-6-3.
//
//

#import <UIKit/UIKit.h>

typedef UIView* (^NoContentViewBlock)();

@interface JJTableViewWithNoContentView : UITableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style noContentViewBlock:(NoContentViewBlock)noContentViewBlock;

@end
