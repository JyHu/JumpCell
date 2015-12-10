//
//  MXYCCloudSelector.m
//  JumpCell
//
//  Created by 胡金友 on 15/12/9.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import "MXYCCloudSelector.h"

/**
 *  @author JyHu, 15-12-09 17:12:30
 *
 *  私有的字符串计算类
 *
 *  @since v6.4.0
 */
@interface NSString (_Helper)

/**
 *  @author JyHu, 15-12-09 17:12:47
 *
 *  计算文字内容的size
 *
 *  @param font 字体
 *
 *  @return size
 *
 *  @since v6.4.0
 */
- (CGSize)_sizeWithFont:(UIFont *)font;

/**
 *  @author JyHu, 15-12-09 17:12:24
 *
 *  计算文字内容所占的宽度
 *
 *  @param font 字体
 *
 *  @return 宽度
 *
 *  @since v6.4.0
 */
- (CGFloat)_widthWithFont:(UIFont *)font;

@end

@implementation NSString (_Helper)

- (CGSize)_sizeWithFont:(UIFont *)font
{
    return [self sizeWithAttributes:@{NSFontAttributeName : font}];
}

- (CGFloat)_widthWithFont:(UIFont *)font
{
    return [self _sizeWithFont:font].width;
}

@end

/**
 *  @author JyHu, 15-12-09 18:12:04
 *
 *  UIView的私有帮助类，方便设置和获取view的属性
 *
 *  @since v6.4.0
 */
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

NSInteger const buttonStartTag = 10000;     // 标签button的起始tag，方便管理和使用
CGFloat const buttonTitleLRAlignment = 20;  // 标签button内容的左右边距
CGFloat const buttonTitleTBAlignment = 10;  // 标签button内容的上下边距

@interface MXYCCloudSelector()

/**
 *  @author JyHu, 15-12-09 18:12:23
 *
 *  缓存的标签数组
 *
 *  @since v6.4.0
 */
@property (retain, nonatomic) NSMutableArray *itemsArray;

/**
 *  @author JyHu, 15-12-09 18:12:50
 *
 *  选择结果的回调block
 *
 *  @since v6.4.0
 */
@property (copy, nonatomic) void (^selectedCompletion)(NSString *title, NSInteger index);

/**
 *  @author JyHu, 15-12-09 18:12:06
 *
 *  已经选择的标签tag数组
 *
 *  @since v6.4.0
 */
@property (retain, nonatomic) NSMutableSet *selectedItemSet;

/**
 *  @author JyHu, 15-12-09 18:12:32
 *
 *  不可操作的按钮的颜色
 *
 *  @since v6.4.0
 */
@property (retain, nonatomic) UIColor *disableButtonColor;

@end

@implementation MXYCCloudSelector

#pragma mark - 一系列的初始化方法

// 初始化方法
- (id)initWithFrame:(CGRect)frame cloudSelectorType:(MXYCCloudSelectorType)type
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.type = type;
        
        [self initilization];
    }
    
    return self;
}

// 初始化方法
- (id)initWithCloudSelectorType:(MXYCCloudSelectorType)type
{
    self = [super init];
    
    if (self)
    {
        self.type = type;
        
        [self initilization];
    }
    
    return self;
}

// 初始化方法
- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self initilization];
    }
    
    return self;
}

// 初始化方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initilization];
    }
    
    return self;
}

// 控制属性的初始化
- (void)initilization
{
    self.maxSelectedItems = NSIntegerMax;
    self.canReselected = NO;
    self.titleColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:13];
    self.alignmentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.disableButtonColor = [UIColor grayColor];
}

#pragma mark - layout methods

/**
 *  @author JyHu, 15-12-09 18:12:57
 *
 *  布局方法
 *
 *  @since v6.4.0
 */
- (void)layoutSubviews
{
    // ------------->
    // 每次在布局之前都需要清空上次布局的数据。
    
    for (id view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self.selectedItemSet removeAllObjects];
    [self.itemsArray removeAllObjects];
    
    //  <<-----------
    
    
    // 标签个数
    NSInteger items = 0;
    
    if (self.type == MXYCCloudSelectorTitleOnly)
    {
        items = [self.titles count];
    }
    else if (self.type == MXYCCloudSelectorComplex)
    {
        NSAssert(self.datasource, @"请设置当前datasource代理方法");
        NSAssert([self.datasource respondsToSelector:@selector(numberOfItemsOfCloudSelector:)],
                 @"请实现 numberOfItemsOfCloudSelector: 代理方法");
        
        items = [self.datasource numberOfItemsOfCloudSelector:self];
    }
    
    /**
     *  @author JyHu, 15-12-09 18:12:39
     *
     *  循环遍历添加标签按钮
     *
     *  @since v6.4.0
     */
    for (NSInteger i = 0; i < items; i ++)
    {
        // 标签的标题
        NSString *curTitle = @"";
        
        if (self.type == MXYCCloudSelectorTitleOnly)
        {
            curTitle = [self.titles objectAtIndex:i];
        }
        else if (self.type == MXYCCloudSelectorComplex)
        {
            NSAssert(self.datasource, @"请设置当前datasource代理方法");
            NSAssert([self.datasource respondsToSelector:@selector(cloudSelector:titleForItemAtIndex:)],
                     @"请实现 cloudSelector:titleForItemAtIndex: 代理方法。");
            
            curTitle = [self.datasource cloudSelector:self titleForItemAtIndex:i];
        }
        
        // 当前标题所占的size
        CGSize tsize = [curTitle _sizeWithFont:self.titleFont];
        
        // 标签的button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, tsize.width + buttonTitleLRAlignment, tsize.height + buttonTitleTBAlignment);
        button.titleLabel.font = self.titleFont;
        button.tag = buttonStartTag + i;
        [button addTarget:self action:@selector(cloudItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:curTitle forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.disableButtonColor forState:UIControlStateDisabled];
        [button setBackgroundColor:[UIColor clearColor]];
        [self addSubview:button];
        
        [self.itemsArray addObject:button];
    }
    
    [self layoutItems];
}

/**
 *  @author JyHu, 15-12-09 18:12:48
 *
 *  重新布局所有标签位置
 *
 *  @since v6.4.0
 */
- (void)layoutItems
{
    CGFloat curXOrigin = self.alignmentInsets.right;
    CGFloat curYOrigin = 20 + self.alignmentInsets.bottom;
    
    for (NSInteger i = 0; i < self.itemsArray.count; i ++)
    {
        UIButton *button = (UIButton *)[self.itemsArray objectAtIndex:i];
        
        if (curXOrigin + self.alignmentInsets.left + button._width + self.alignmentInsets.right > self._width)
        {
            curXOrigin = self.alignmentInsets.right;
            curYOrigin += (self.alignmentInsets.top + button._height + self.alignmentInsets.bottom);
        }
        
        button._xOrigin = curXOrigin;
        button._yOrigin = curYOrigin;
        
        curXOrigin += (self.alignmentInsets.left + button._width + self.alignmentInsets.right);
    }
}

#pragma mark - responsed methods

/**
 *  @author JyHu, 15-12-09 18:12:35
 *
 *  标签被选择的方法
 *
 *  @param button <#button description#>
 *
 *  @since <#v6.4.0#>
 */
- (void)cloudItemSelected:(UIButton *)button
{
    /**
     *  @author JyHu, 15-12-09 18:12:21
     *
     *  达到了最大的可选择的数量
     *
     *  @since v6.4.0
     */
    if (self.selectedItemSet.count >= self.maxSelectedItems)
    {
#warning - alert
        NSLog(@"点击的个数太多");
        return;
    }
    
    if (!self.canReselected)
    {
        /**
         *  @author JyHu, 15-12-09 18:12:08
         *
         *  禁止标签再次被选择
         *
         *  @since v6.4.0
         */
        button.enabled = NO;
    }
    
    /**
     *  @author JyHu, 15-12-09 18:12:43
     *
     *  缓存已经点击过的标签的tag
     *
     *  @since v6.4.0
     */
    [self.selectedItemSet addObject:@(button.tag)];
    
    /**
     *  @author JyHu, 15-12-09 18:12:31
     *
     *  标签点击后的回调
     *
     *  @since v6.4.0
     */
    
    if (self.type == MXYCCloudSelectorTitleOnly)
    {
        if (self.selectedCompletion)
        {
            self.selectedCompletion(button.titleLabel.text, button.tag - buttonStartTag);
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cloudSelector:selectedItemAtIndex:)])
        {
            [self.delegate cloudSelector:self selectedItemAtIndex:button.tag - buttonStartTag];
        }
    }
}

/**
 *  @author JyHu, 15-12-09 18:12:38
 *
 *  重新使某个标签能够点击
 *
 *  @param index 标签的编号
 *
 *  @since v6.4.0
 */
- (void)resumActiveForIndex:(NSInteger)index
{
    if ([self.selectedItemSet containsObject:@(index + buttonStartTag)])
    {
        [self.selectedItemSet removeObject:@(index + buttonStartTag)];
        
        UIButton *button = (UIButton *)[self viewWithTag:index + buttonStartTag];
        
        button.enabled = YES;
    }
}

/**
 *  @author JyHu, 15-12-09 18:12:21
 *
 *  设置选择标签后的回调方法
 *
 *  @param selectedCompleton 回调的block
 *
 *  @since v6.4.0
 */
- (void)selectedCompletion:(void (^)(NSString *, NSInteger))selectedCompleton
{
    if (selectedCompleton)
    {
        _selectedCompletion = selectedCompleton;
    }
}

#pragma mark - getter & setter

/**
 *  @author JyHu, 15-12-09 18:12:07
 *
 *  缓存标签的数组
 *
 *  @return NSMutableArray
 *
 *  @since v6.4.0
 */
- (NSMutableArray *)itemsArray
{
    if (!_itemsArray)
    {
        _itemsArray = [[NSMutableArray alloc] init];
    }
    
    return _itemsArray;
}

/**
 *  @author JyHu, 15-12-09 18:12:36
 *
 *  已选择标签缓存集合的getter方法
 *
 *  @return NSMutableSet
 *
 *  @since v6.4.0
 */
- (NSMutableSet *)selectedItemSet
{
    if (!_selectedItemSet)
    {
        _selectedItemSet = [[NSMutableSet alloc] init];
    }
    
    return _selectedItemSet;
}

/**
 *  @author JyHu, 15-12-09 18:12:55
 *
 *  标签标题颜色的setter方法
 *
 *  @param titleColor 标签标题颜色
 *
 *  @since v6.4.0
 */
- (void)setTitleColor:(UIColor *)titleColor
{
    if (titleColor)
    {
        _titleColor = titleColor;
        
        if (self.itemsArray.count > 0)
        {
            
            /**
             *  @author JyHu, 15-12-09 18:12:24
             *
             *  遍历去设置标签标题的颜色
             *
             *  @since v6.4.0
             */
            for (NSInteger i = 0; i < self.itemsArray.count; i ++)
            {
                UIButton *button = (UIButton *)[self.itemsArray objectAtIndex:i];
                
                [button setTitleColor:titleColor forState:UIControlStateNormal];
            }
            
            [self layoutItems];
        }
    }
}

/**
 *  @author JyHu, 15-12-09 18:12:18
 *
 *  标签字体的setter方法
 *
 *  @param titleFont 标签字体
 *
 *  @since v6.4.0
 */
- (void)setTitleFont:(UIFont *)titleFont
{
    if (titleFont)
    {
        _titleFont = titleFont;
        
        if (self.itemsArray.count > 0)
        {
            /**
             *  @author JyHu, 15-12-09 18:12:37
             *
             *  遍历去设置所有的标签的字体
             *
             *  @since v6.4.0
             */
            for (NSInteger i = 0; i < self.itemsArray.count; i ++)
            {
                UIButton *button = (UIButton *)[self.itemsArray objectAtIndex:i];
                
                CGSize size = [button.titleLabel.text _sizeWithFont:titleFont];
                
                button.titleLabel.font = titleFont;
                button._width = size.width + buttonTitleLRAlignment;
                button._height = size.height + buttonTitleTBAlignment;
            }
            
            [self layoutItems];
        }
    }
}

/**
 *  @author JyHu, 15-12-09 18:12:54
 *
 *  设置位置的setter方法
 *
 *  @param alignmentInsets UIEdgeInsets
 *
 *  @since v6.4.0
 */
- (void)setAlignmentInsets:(UIEdgeInsets)alignmentInsets
{
    _alignmentInsets = alignmentInsets;
    
    [self layoutItems];
}

/**
 *  @author JyHu, 15-12-09 18:12:41
 *
 *  标题的setter方法
 *
 *  @param titles 标题数组
 *
 *  @since v6.4.0
 */
- (void)setTitles:(NSArray *)titles
{
    if (titles)
    {
        _titles = titles;
    }
    
    [self setNeedsLayout];
}

@end
