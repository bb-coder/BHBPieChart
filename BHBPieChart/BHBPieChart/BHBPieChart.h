//
//  BHBPieChart.h
//  BHBPieChart
//
//  Created by bihongbo on 16/2/22.
//  Copyright © 2016年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kPieAnimationTypeLiner,//线性增长，顺时针绘制
    kPieAnimationTypeChangeValue//值变化，迁移状态
} kPieAnimationType;

@interface BHBPieChart : UIView

/**
 *  数据的数组，饼图按照这个数据进行分布。赋值之后会更新UI，需要注意的是请事先提供colorsArray，否则线条可能全是灰色的。
 */
@property (nonatomic, strong) NSArray * numbersArray;
/**
 *  对应每一条数据有一个颜色值。
 */
@property (nonatomic, strong) NSArray * colorsArray;

@property (nonatomic, assign) CGFloat startAngle;//饼图绘制起点默认为-M_PI_2

@property (nonatomic, assign) CGFloat endAngle;//饼图绘制起点默认为3 * M_PI_2

/**
 *  默认饼图背景颜色。
 */
@property (nonatomic, strong) UIColor * lineBackgroudColor;//

/**
 *  线条与线条之间的间隔。
 */
@property (nonatomic, assign) CGFloat linespace;//默认2
/**
 *  饼图宽度。
 */
@property (nonatomic, assign) CGFloat lineWidth;//默认30

/**
 *  动画时间
 */
@property (nonatomic, assign) CGFloat animationDuration;//动画时间 默认0.8秒

@property (nonatomic, assign) BOOL allowAnimation;//默认YES 是否开启动画

@property (nonatomic, assign) kPieAnimationType animationType;//默认线性增长




@end
