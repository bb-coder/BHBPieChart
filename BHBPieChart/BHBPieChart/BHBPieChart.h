//
//  BHBPieChart.h
//  BHBPieChart
//
//  Created by bihongbo on 16/2/22.
//  Copyright © 2016年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHBPieChart : UIView

/**
 *  数据的数组，饼图按照这个数据进行分布。
 */
@property (nonatomic, strong) NSArray * numbersArray;
/**
 *  对应每一条数据有一个颜色值。
 */
@property (nonatomic, strong) NSArray * colorsArray;
/**
 *  默认饼图背景颜色。
 */
@property (nonatomic, strong) UIColor * lineBackgroudColor;
/**
 *  线条与线条之间的间隔。
 */
@property (nonatomic, assign) CGFloat linespace;
/**
 *  饼图宽度。
 */
@property (nonatomic, assign) CGFloat lineWidth;




@end
