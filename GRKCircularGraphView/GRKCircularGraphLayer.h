//
//  GRKCircularGraphLayer.h
//
//  Created by Levi Brown on August 6, 2014.
//  Copyright (c) 2014-2017 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import <QuartzCore/QuartzCore.h>

@interface GRKCircularGraphLayer : CALayer

/**
 *  The media timing function to use when animating.
 *  This defaults to the timing function specified by the `kCAMediaTimingFunctionEaseOut` name.
 *  To change, set this property to the result of the `functionWithName:` method on `CAMediaTimingFunction`, like:
 *  `[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]`
 */
@property (nonatomic,assign) CAMediaTimingFunction *mediaTimingFunction;
/**
 *  The time duration animations should use. If set to zero, no animation will take place when property values are set.
 *  The default is zero (no animations).
 */
@property (nonatomic,assign) NSTimeInterval animationDuration;
/**
 *  The percentage to display in the graph. This should be a value between 0.0 and 1.0.
 */
@property (nonatomic,assign) CGFloat percent;
/**
 *  The color to use for the indicator of the graph.
 */
@property (nonatomic,assign) CGColorRef color;
/**
 *  The thickness of the graph indicator to draw.
 *  This defaults to 10.0.
 */
@property (nonatomic) CGFloat indicatorThickness;
/**
 *  The "zero" position of our graph indicator.
 *  This is the radian value where zero is the horizontal axis on the right hand side ("3 o'clock').
 *  Defaults to `M_PI_2 * 3` (12:00 o'clock)
 */
@property (nonatomic,assign) CGFloat startAngle;
/**
 *  The fill direction of the graph.
 *  Defaults to `YES`, meaning the represented value will be the percentage of the circle from startAngle to the value in a clockwise direction.
 *  i.e. if the `percent` is `0.25` and the `startAngle` is `M_PI_2 * 3 (12:00 o'clock), then the graph will be filled from 12:00 to 3:00.
 *  If `NO` in the same situation, then the graph would be filled from 12:00 to 9:00.
 */
@property (nonatomic,assign) BOOL clockwise;

@end
