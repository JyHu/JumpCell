//
//  AUUStepMenu.m
//  JumpCell
//
//  Created by 胡金友 on 15/12/10.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import "AUUStepMenu.h"
#import <objc/runtime.h>

@interface UITableView (_Helper)

/**
 *  @author JyHu, 15-12-10 17:12:16
 *
 *  给tableView扩展一个属性，记录当前table的数据源
 *
 *  @since v1.0
 */
@property (retain, nonatomic) NSArray *datasArray;

@end

/**
 *  @author JyHu, 15-12-10 17:12:49
 *
 *  runtime保存数据的时候的key
 *
 *  @since v1.0
 */
static void * datasourceArrayKey = (void *)@"datasourceArrayKey";

@implementation UITableView (_Helper)

/**
 *  @author JyHu, 15-12-10 17:12:22
 *
 *  数据源的getter方法
 *
 *  @return 数据源数组
 *
 *  @since v1.0
 */
- (NSArray *)datasArray
{
    return objc_getAssociatedObject(self, datasourceArrayKey);
}

/**
 *  @author JyHu, 15-12-10 17:12:38
 *
 *  保存当前table的数据源
 *
 *  @param datasArray 数据源
 *
 *  @since v1.0
 */
- (void)setDatasArray:(NSArray *)datasArray
{
    objc_setAssociatedObject(self,
                             datasourceArrayKey,
                             datasArray,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface UIView (_Helper)

@property (assign, nonatomic) CGFloat _xOrigin;     // x坐标
@property (assign, nonatomic) CGFloat _yOrigin;     // y坐标
@property (assign, nonatomic) CGFloat _width;       // 宽度
@property (assign, nonatomic) CGFloat _height;      // 高度
@property (assign, nonatomic, readonly) CGFloat _maxXOrigin;    // 最大的x坐标
@property (assign, nonatomic, readonly) CGFloat _maxYOrigin;    // 做大的y坐标

@end

@implementation UIView (_Helper)

- (CGFloat)_xOrigin { return self.frame.origin.x; }

- (void)set_xOrigin:(CGFloat)_xOrigin
{
    CGRect rect = self.frame;
    rect.origin.x = _xOrigin;
    self.frame = rect;
}

- (CGFloat)_yOrigin { return self.frame.origin.y; }

- (void)set_yOrigin:(CGFloat)_yOrigin
{
    CGRect rect = self.frame;
    rect.origin.y = _yOrigin;
    self.frame = rect;
}

- (CGFloat)_width { return self.frame.size.width; }

- (void)set_width:(CGFloat)_width
{
    CGRect rect = self.frame;
    rect.size.width = _width;
    self.frame = rect;
}

- (CGFloat)_height { return self.frame.size.height; }

- (void)set_height:(CGFloat)_height
{
    CGRect rect = self.frame;
    rect.size.height = _height;
    self.frame = rect;
}

- (CGFloat)_maxXOrigin { return self._width + self._xOrigin; }

- (CGFloat)_maxYOrigin { return self._height + self._yOrigin; }

@end

/**
 *  @author JyHu, 15-12-10 17:12:33
 *
 *  每级菜单table的起始tag
 *
 *  @since v1.0
 */
NSInteger const menuStartTag = 10000;

/**
 *  @author JyHu, 15-12-10 17:12:08
 *
 *  菜单位置变换的动画时间
 *
 *  @since v1.0
 */
CGFloat const defaultAnimationDuration = 0.5;

@interface AUUStepMenu() <UITableViewDelegate, UITableViewDataSource>

/**
 *  @author JyHu, 15-12-10 17:12:25
 *
 *  每级菜单选择的时候的block回调
 *
 *  @since v1.0
 */
@property (copy, nonatomic) void (^selectedCompletion)( NSArray *currentDatasource,
                                                        NSInteger index,
                                                        BOOL hadAdditionalMenu);

/**
 *  @author JyHu, 15-12-10 17:12:07
 *
 *  显示到当前分级菜单有多少级
 *
 *  @since v1.0
 */
@property (assign, nonatomic) NSInteger menuCount;

@end

@implementation AUUStepMenu

#pragma mark - 一系列初始化方法

- (id)initWithFrame:(CGRect)frame andDatasource:(NSArray *)datasource
{
    if (self = [super initWithFrame:frame])
    {
        if (datasource)
        {
            // 初始化一些属性。
            
            self.clipsToBounds = YES;
            self.maxMenuStepsInScreen = 3;
            self.datasource = datasource;
        }
    }
    
    return self;
}

- (id)initWithDatasource:(NSArray *)datasource
{
    return [self initWithFrame:CGRectZero andDatasource:datasource];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andDatasource:nil];
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - getter & setter

/**
 *  @author JyHu, 15-12-10 17:12:22
 *
 *  设置菜单数据源
 *
 *  @param datasource 数据源
 *
 *  @since v1.0
 */
- (void)setDatasource:(NSArray *)datasource
{
    if (datasource)
    {
        _datasource = datasource;
        
        // 先清空当前菜单页面上的所有分级菜单
        [self removeSubmenuBehindTag:menuStartTag - 1];
        
        if (self.menuCount > 0)
        {
            // 说明当前页面显示过了，就需要重新刷新页面。
            [self setNeedsLayout];
        }
        
        // 初始化当前分级菜单的级数。
        self.menuCount = 0;
    }
}

#pragma mark - handle methods

/**
 *  @author JyHu, 15-12-10 17:12:39
 *
 *  设置选择菜单的回调
 *
 *  @param selectedCompletion 回调的block
 *
 *  @since v1.0
 */
- (void)menuSelectedCompletion:(void (^)(NSArray *, NSInteger, BOOL))selectedCompletion
{
    if (selectedCompletion)
    {
        self.selectedCompletion = selectedCompletion;
    }
}

#pragma mark - layout methods

/**
 *  @author JyHu, 15-12-10 17:12:24
 *
 *  页面刷新的时候调用
 *
 *  @since v1.0
 */
- (void)layoutSubviews
{
    [self addATableWithDatasource:self.datasource tag:menuStartTag];
}

/**
 *  @author JyHu, 15-12-10 17:12:42
 *
 *  重新设置所有菜单的位置
 *
 *  @since v1.0
 */
- (void)relayoutSubmenus
{
    // 每级菜单的宽度
    CGFloat pwidth = self._width / ((self.menuCount > self.maxMenuStepsInScreen ?
                                     self.maxMenuStepsInScreen : self.menuCount) * 1.0);
    
    // 菜单位置变化的动画时间
    CGFloat duration = defaultAnimationDuration;
    
    if (self.menuCount == 1)
    {
        // 如果是初始化页面的话，第一级菜单的布局不需要动画时间
        duration = 0;
    }
    
    [UIView animateWithDuration:duration animations:^{
        
        // 遍历去设置每级菜单的位置
        for (NSInteger i = 0; i < self.menuCount; i ++)
        {
            UITableView *table = (UITableView *)[self viewWithTag:i + menuStartTag];
            
            table._width = pwidth;
            table._xOrigin = pwidth * (self.menuCount > self.maxMenuStepsInScreen ?
                                       i - (self.menuCount - self.maxMenuStepsInScreen) : i);
        }
    }];
}

/**
 *  @author JyHu, 15-12-10 17:12:18
 *
 *  移除分级菜单的后续菜单
 *
 *  @param tag 当前选择菜单的tag
 *
 *  @since v1.0
 */
- (void)removeSubmenuBehindTag:(NSInteger)tag
{
    // 遍历去移除
    for (NSInteger i = tag + 1; i < menuStartTag + self.menuCount; i ++)
    {
        UITableView *table = (UITableView *)[self viewWithTag:i];
        
        if (table)
        {
            // 先移动到当前多级菜单页面的右边，然后在移除
            [UIView animateWithDuration:defaultAnimationDuration animations:^{
                
                table._xOrigin = self._width;
                
            } completion:^(BOOL finished) {
                
                [table removeFromSuperview];
            }];
        }
    }
    
    // 重设页面上菜单级数记录
    self.menuCount = tag - menuStartTag + 1;
    
    [self relayoutSubmenus];
}

#pragma mark - table view delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableView.datasArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"identifier_%zd_%zd",indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    id currentData = [tableView.datasArray objectAtIndex:indexPath.row];
    
    // 如果当前数据是字符串的话，直接添加
    if ([currentData isKindOfClass:[NSString class]])
    {
        cell.textLabel.text = currentData;
    }
    // 如果当前数据是字典的话，则说明还有子菜单
    else if ([currentData isKindOfClass:[NSDictionary class]])
    {
        cell.textLabel.text = [[(NSDictionary *)currentData allKeys] firstObject];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentData = [tableView.datasArray objectAtIndex:indexPath.row];
    
    if ([currentData isKindOfClass:[NSString class]])
    {
        // 如果当前级菜单不是最后一级，需要移除后面的所有子菜单
        if (tableView.tag < self.menuCount + menuStartTag - 1)
        {
            [self removeSubmenuBehindTag:tableView.tag];
        }
        
        if (self.selectedCompletion)
        {
            // 回调
            self.selectedCompletion(tableView.datasArray, indexPath.row, NO);
        }
    }
    else if ([currentData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictData = (NSDictionary *)currentData;
        
        
        // 当前数据是字典，说明还有子菜单，就添加一个子菜单到当前页面
        [self addATableWithDatasource:[dictData objectForKey:[[dictData allKeys] firstObject]]
                                  tag:tableView.tag + 1];
        
        self.selectedCompletion(tableView.datasArray, indexPath.row, YES);
    }
}

#pragma mark - help methods

/**
 *  @author JyHu, 15-12-10 17:12:07
 *
 *  添加一级菜单到页面上
 *
 *  @param datas 当前级菜单的数据源
 *  @param tag   当前级菜单的tag
 *
 *  @since v1.0
 */
- (void)addATableWithDatasource:(NSArray *)datas tag:(NSInteger)tag
{
    if ([self viewWithTag:tag])
    {
        // 如果页面上有这一级菜单的话，则需要返回，不然的话，会重复添加到页面上
        return;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds
                                                          style:UITableViewStylePlain];
    tableView._xOrigin = self._width;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tag = tag;
    tableView.datasArray = datas;
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    
    // 当前页面上有的菜单的级数
    self.menuCount = tag - menuStartTag + 1;
    
    // 添加一级菜单后，重新布局页面菜单
    [self relayoutSubmenus];
}

@end
