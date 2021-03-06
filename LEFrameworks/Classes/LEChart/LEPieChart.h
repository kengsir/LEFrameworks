//
//  LEPieChart.h
//  LEPieChart
//
//  Created by XY Feng on 2/24/12. Modified By LarryEmerson
//  Copyright (c) 2012 Xiaoyang Feng. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "LEUIFramework.h"

@class LEPieChart;
@protocol LEPieChartDataSource <NSObject>
@required
- (NSUInteger)numberOfSlicesInPieChart:(LEPieChart *)pieChart;
- (CGFloat)pieChart:(LEPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index;
@optional
- (UIColor *)pieChart:(LEPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index;
- (NSString *)pieChart:(LEPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index;
@end

@protocol LEPieChartDelegate <NSObject>
@optional
- (void)pieChart:(LEPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(LEPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(LEPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(LEPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index;
@end

@interface LEPieChart : UIView
@property(nonatomic, weak) id<LEPieChartDataSource> dataSource;
@property(nonatomic, weak) id<LEPieChartDelegate> delegate;
@property(nonatomic, assign) CGFloat startPieAngle;
@property(nonatomic, assign) CGFloat animationSpeed;
@property(nonatomic, assign) CGPoint pieCenter;
@property(nonatomic, assign) CGFloat pieRadius;
@property(nonatomic, assign) BOOL    showLabel;
@property(nonatomic, strong) UIFont  *labelFont;
@property(nonatomic, strong) UIColor *labelColor;
@property(nonatomic, strong) UIColor *labelShadowColor;
@property(nonatomic, assign) CGFloat labelRadius;
@property(nonatomic, assign) CGFloat selectedSliceStroke;
@property(nonatomic, assign) CGFloat selectedSliceOffsetRadius;
@property(nonatomic, assign) BOOL    showPercentage;
- (id)initWithFrame:(CGRect)frame Center:(CGPoint)center Radius:(CGFloat)radius;
- (void)reloadData;
- (void)setPieBackgroundColor:(UIColor *)color;

- (void)setSliceSelectedAtIndex:(NSInteger)index;
- (void)setSliceDeselectedAtIndex:(NSInteger)index;

@end;
