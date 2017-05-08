//
//  GRKCircularGraphBackingLayer.m
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

#import "GRKCircularGraphBackingLayer.h"
#import "GRKCircularGraphLayer.h"

static CGFloat const kDefaultBorderThickness = 1.0f;

@implementation GRKCircularGraphBackingLayer

@dynamic color, fillColor, borderThickness, borderOffset;

#pragma mark - Class Level

+ (NSSet *)displayKeys
{
    static NSSet *keys = nil;
    if (!keys)
    {
        keys = [NSSet setWithObjects:@"color", @"fillColor", @"borderThickness", @"borderOffset", @"bounds", nil];
    }
    
    return keys;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([[self displayKeys] containsObject:key])
    {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        [self setup];
        
        //Copy custom property values into our new instance from the given layer
        GRKCircularGraphBackingLayer *baseLayer = (GRKCircularGraphBackingLayer *)layer;
        self.color = baseLayer.color;
        self.fillColor = baseLayer.fillColor;
        self.borderThickness = baseLayer.borderThickness;
		self.borderOffset = baseLayer.borderOffset;
    }
    return self;
}

- (void)setup
{
    self.borderThickness = kDefaultBorderThickness;
}

#pragma mark - Layout

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    //We want our graph layer to have our bounds, inset by our border thickness
    CGRect subLayerRect = CGRectInset(self.bounds, self.borderThickness, self.borderThickness);
    for (CALayer *sublayer in self.sublayers)
    {
        if ([sublayer isKindOfClass:GRKCircularGraphLayer.class])
        {
            sublayer.frame = subLayerRect;
            break;
        }
    }
}

#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)context
{
    if (self.borderThickness > 0.0f)
    {
        CGPoint center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
        //The radius (minimum of center.x and center.y so we will not draw out of bounds)
        CGFloat radius = MIN(center.y, center.x);
        //Adjust the radius for the line width (again so we don't draw out of bounds)
        radius -= (self.borderThickness / 2.0f) - self.borderOffset;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0.0f endAngle:2.0f * M_PI clockwise:YES];
        
        CGContextSetLineWidth(context, self.borderThickness);
        CGContextSetStrokeColorWithColor(context, self.color);
        CGContextAddPath(context, path.CGPath);
        CGContextSetFillColorWithColor(context, self.fillColor);
        CGPathDrawingMode drawingMode = self.fillColor ? kCGPathFillStroke : kCGPathStroke;
        CGContextDrawPath(context, drawingMode);
    }
}

@end
