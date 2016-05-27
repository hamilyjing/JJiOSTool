//
//  JJTableViewWithNoContentView.m
//  clientUI
//
//  Created by Gong Jian on 14-6-3.
//
//

#import "JJTableViewWithNoContentView.h"

#import "JJTableViewDataSource.h"
#import "UITableView+JJDataSource.h"

extern NSString *const UITableViewDataSourceObjectCreated;

static const NSInteger TagNoContentView = 239709090;

@interface JJTableViewWithNoContentView ()

@property (nonatomic, copy) NoContentViewBlock noContentViewBlock;
@property (nonatomic, strong) JJTableViewDataSource *dataSourceObjectBackUp;

@end

@implementation JJTableViewWithNoContentView

- (void)dealloc
{
    if (self.dataSourceObjectBackUp)
    {
        [self.dataSourceObjectBackUp removeObserver:self forKeyPath:@"items"];
    }
    
    [self removeObserver:self forKeyPath:@"frame"];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    NSAssert(NO, nil);
    return nil;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style noContentViewBlock:(NoContentViewBlock)noContentViewBlock
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.noContentViewBlock = noContentViewBlock;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(dataSourceObjectCreatedNotification) name:UITableViewDataSourceObjectCreated object:self];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

#pragma mark - UITableViewDataSourceObjectCreated notification
- (void)dataSourceObjectCreatedNotification
{
    if (self.dataSourceObject)
    {
        [self.dataSourceObject addObserver:self forKeyPath:@"items" options:NSKeyValueObservingOptionNew context:nil];
    }
    else
    {
        [self.dataSourceObjectBackUp removeObserver:self forKeyPath:@"items"];
    }
    
    self.dataSourceObjectBackUp = self.dataSourceObject;
    
    [self noContentViewShownOrNot];
}

#pragma mark - observe

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"items"])
    {
        [self noContentViewShownOrNot];
    }
    else if ([keyPath isEqualToString:@"frame"])
    {
        [self noContentViewShownOrNot];
    }
}

#pragma mark - Private

- (void)noContentViewShownOrNot
{
    BOOL isShow = (0 == [self.dataSourceObject.items count]);
    UIView *noContentView = [self viewWithTag:TagNoContentView];
    
    if (!isShow)
    {
        [noContentView removeFromSuperview];
        return;
    }
    
    if (!noContentView && self.noContentViewBlock)
    {
        noContentView = self.noContentViewBlock();
        noContentView.tag = TagNoContentView;
        [self addSubview:noContentView];
    }
    
    noContentView.frame = self.bounds;
    [noContentView setNeedsLayout];
}

@end
