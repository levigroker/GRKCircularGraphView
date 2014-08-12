//
//  GRKCircularGraphView.h
//
//  Created by Levi Brown on August 6, 2014.
//  Copyright (c) 2014 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import <UIKit/UIKit.h>

@interface GRKCircularGraphView : UIView

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
 *  The percentage to display in the graph. This will be pinned to a minimum of 0.0 and a maximum of 1.0.
 */
@property (nonatomic,assign) CGFloat percent;
/**
 *  The color to use for the bar of the graph, if you wish to use a separate color than the tintColor.
 *  @see barColorUsesTintColor
 *  @see tintColor
 */
@property (nonatomic,strong) UIColor *indicatorColor;
/**
 *  If `YES` then the `barColor` will be the same as the `tintColor` and changes to the `tintColor` will also change the `barColor`.
 *  If `NO` then changes to `tintColor` will not change the `barColor`.
 *  The default is `YES`
 *  @see barColor
 *  @see tintColor
 */
@property (nonatomic,assign) BOOL indicatorColorUsesTintColor;
/**
 *  The thickness of the graph indicator to draw.
 *  This defaults to 10.0.
 */
@property (nonatomic) CGFloat indicatorThickness;
/**
 *  The thickness of the border to draw.
 *  This defaults to 1.0.
 */
@property (nonatomic) CGFloat borderThickness;
/**
 *  The color to use to fill the circle background (can be `nil`).
 */
@property (nonatomic,strong) UIColor *fillColor;
/**
 *  The "zero" position of our graph indicator.
 *  This is the radian value where zero is the horizontal axis on the right hand side ("3 o'clock').
 *  Defaults to `M_PI_2 * 3` (12:00 o'clock)
 */
@property (nonatomic,assign) CGFloat startAngle;
/**
 *  The fill direction of the graph.
 *  Defaults to `YES`, meaning the represented value will be the percentage of the circle from startAngle to the value in a clockwise direction.
 *  i.e. if the `percent` is `0.25` and the `startAngle` is `-M_PI_2` (12:00 o'clock), then the graph will be filled from 12:00 to 3:00.
 *  If `NO` in the same situation, then the graph would be filled from 12:00 to 9:00.
 */
@property (nonatomic,assign) BOOL clockwise;

@end
