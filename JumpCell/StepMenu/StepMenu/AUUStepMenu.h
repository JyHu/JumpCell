//
//  AUUStepMenu.h
//  JumpCell
//
//  Created by 胡金友 on 15/12/10.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUUStepMenu : UIView

/**
 *  @author JyHu, 15-12-10 17:12:00
 *
 *  初始化方法
 *
 *  @param frame      CGRect
 *  @param datasource 菜单条目数据源
 *
 *  @return self
 *
 *  @since v1.0
 */
- (id)initWithFrame:(CGRect)frame andDatasource:(NSArray *)datasource;

/**
 *  @author JyHu, 15-12-10 17:12:20
 *
 *  初始化方法
 *
 *  @param datasource 菜单条目数据源
 *
 *  @return self
 *
 *  @since v1.0
 */
- (id)initWithDatasource:(NSArray *)datasource;

/**
 *  @author JyHu, 15-12-10 17:12:31
 *
 *  菜单条目数据源
 *
 *  @since v1.0
 */
@property (retain, nonatomic) NSArray *datasource;

/**
 *  @author JyHu, 15-12-10 17:12:07
 *
 *  当前屏幕显示的分级菜单的级数
 *
 *  @since v1.0
 */
@property (assign, nonatomic) NSInteger maxMenuStepsInScreen;

/**
 *  @author JyHu, 15-12-10 17:12:44
 *
 *  菜单在每次选择后的回调
 *
 *  @param selectedCompletion 回调的block
 *
 *  @since v1.0
 */
- (void)menuSelectedCompletion:(void (^)(NSArray *currentDatasource,
                                         NSInteger index,
                                         BOOL hadAdditionalMenu))selectedCompletion;

@end