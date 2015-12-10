//
//  MXYCCloudSelector.h
//  JumpCell
//
//  Created by 胡金友 on 15/12/9.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXYCCloudSelector;

@protocol MXYCCloudSelectorDataSource <NSObject>

/**
 *  @author JyHu, 15-12-09 14:12:15
 *
 *  标签的个数
 *
 *  @param selector 当前的云标签
 *
 *  @return self
 *
 *  @since v6.4.0
 */
- (NSInteger)numberOfItemsOfCloudSelector:(MXYCCloudSelector *)selector;

/**
 *  @author JyHu, 15-12-09 14:12:12
 *
 *  云标签的标题
 *
 *  @param selector 云标签
 *  @param index    标题的位置
 *
 *  @return 标题名
 *
 *  @since v6.4.0
 */
- (NSString *)cloudSelector:(MXYCCloudSelector *)selector titleForItemAtIndex:(NSInteger)index;

@end

@protocol MXYCCloudSelectorDelegate <NSObject>

/**
 *  @author JyHu, 15-12-09 14:12:44
 *
 *  云标签被选择后的代理回调
 *
 *  @param selector 云标签
 *  @param index    位置
 *
 *  @since v6.4.0
 */
- (void)cloudSelector:(MXYCCloudSelector *)selector selectedItemAtIndex:(NSInteger)index;

@end

/**
 *  @author JyHu, 15-12-09 14:12:31
 *
 *  云标签的类型枚举
 *
 *  @since v6.4.0
 */
typedef NS_ENUM(NSUInteger, MXYCCloudSelectorType) {
    /**
     *  @author JyHu, 15-12-09 14:12:31
     *
     *  数据源中只有标签的标题
     *
     *  @since v6.4.0
     */
    MXYCCloudSelectorTitleOnly,
    /**
     *  @author JyHu, 15-12-09 14:12:31
     *
     *  数据源是复杂的类型，比如字典、model
     *
     *  @since v6.4.0
     */
    MXYCCloudSelectorComplex
};

@interface MXYCCloudSelector : UIView

#pragma mark - 初始化方法

/**
 *  @author JyHu, 15-12-09 14:12:13
 *
 *  初始化方法
 *
 *  @param frame CGRect
 *  @param type  云标签的类型
 *
 *  @return self
 *
 *  @since v6.4.0
 */
- (id)initWithFrame:(CGRect)frame cloudSelectorType:(MXYCCloudSelectorType)type;

/**
 *  @author JyHu, 15-12-09 14:12:43
 *
 *  初始化的方法
 *
 *  @param type 云标签的类型
 *
 *  @return self
 *
 *  @since v6.4.0
 */
- (id)initWithCloudSelectorType:(MXYCCloudSelectorType)type;

/**
 *  @author JyHu, 15-12-09 14:12:20
 *
 *  云标签的类型，必须的，如果初始化中有了，这里可以不设置
 *
 *  @since v6.4.0
 */
@property (assign, nonatomic) MXYCCloudSelectorType type;

/**
 *  @author JyHu, 15-12-09 14:12:26
 *
 *  最大的可选择数，非必选，默认无限个
 *
 *  @since v6.4.0
 */
@property (assign, nonatomic) NSInteger maxSelectedItems;

/**
 *  @author JyHu, 15-12-09 14:12:44
 *
 *  对于同一个标签是否可以重复选择，非必选，默认 NO
 *
 *  @since v6.4.0
 */
@property (assign, nonatomic) BOOL canReselected;

/**
 *  @author JyHu, 15-12-09 14:12:03
 *
 *  如果只能选择一次的话，恢复可选状态的方法
 *
 *  @param index 恢复可选状态的位置
 *
 *  @since v6.4.0
 */
- (void)resumActiveForIndex:(NSInteger)index;

/**
 *  @author JyHu, 15-12-09 14:12:38
 *
 *  标签的颜色，非必选
 *
 *  @since v6.4.0
 */
@property (retain, nonatomic) UIColor *titleColor;

/**
 *  @author JyHu, 15-12-09 14:12:48
 *
 *  标签的字体，非必选
 *
 *  @since v6.4.0
 */
@property (retain, nonatomic) UIFont *titleFont;

/**
 *  @author JyHu, 15-12-09 14:12:28
 *
 *  标签边距，非必选
 *
 *  @since v6.4.0
 */
@property (assign, nonatomic) UIEdgeInsets alignmentInsets;

#pragma mark - 如果每个标签的属性是复杂类型，则需要走代理的方式，复杂属性指的是字典、model等

/**
 *  @author JyHu, 15-12-09 14:12:01
 *
 *  代理
 *
 *  @since v6.4.0
 */
@property (assign, nonatomic) id<MXYCCloudSelectorDelegate> delegate;

/**
 *  @author JyHu, 15-12-09 14:12:07
 *
 *  数据内容
 *
 *  @since v6.4.0
 */
@property (assign, nonatomic) id<MXYCCloudSelectorDataSource> datasource;

#pragma mark - 如果只有title的话，不需要代理，只需要走下面的方法和属性就行。

/**
 *  @author JyHu, 15-12-09 14:12:18
 *
 *  标签标题的数组，必须的属性
 *
 *  @since v6.4.0
 */
@property (retain, nonatomic) NSArray *titles;

/**
 *  @author JyHu, 15-12-09 14:12:45
 *
 *  标签被选择后的block回调
 *
 *  @param selectedCompleton Block回调
 *
 *  @since v6.4.0
 */
- (void)selectedCompletion:(void (^)(NSString *title, NSInteger index))selectedCompleton;

@end
