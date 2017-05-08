//
//  GRKCircularGraphBackingLayer.h
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

@interface GRKCircularGraphBackingLayer : CALayer

/**
 *  The color used to draw the border.
 */
@property (nonatomic,assign) CGColorRef color;
/**
 *  The thickness of the border to draw.
 *  This defaults to 1.0.
 */
@property (nonatomic,assign) CGFloat borderThickness;
/**
 *  A radial offset to draw border at. Negative values shrink the radius.
 *  This defaults to 0.0.
 */
@property (nonatomic,assign) CGFloat borderOffset;
/**
 *  The color to use to fill the circle background.
 */
@property (nonatomic,assign) CGColorRef fillColor;

@end
