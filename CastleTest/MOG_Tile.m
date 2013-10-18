//
//  MOG_Tile.m
//  CastleTest
//
//  Created by Steven Christe on 10/15/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import "MOG_Tile.h"
@interface MOG_Tile()
-(UIImage *) loadTile:(CGPoint)location;
-(UIImage *) getSubImageFrom: (UIImage*) img withRect: (CGRect) rect;
@end


@implementation MOG_Tile

@synthesize image = _image;

- (id)init:(CGPoint)tileLocation{
    self = [super init];
    if (self) {
        _image = [self loadTile:tileLocation];
    }
    return self;
}

-(UIImage *)loadTile:(CGPoint)location{
    int tile_size_x = 16;
    int tile_size_y = 16;
    
    UIImage *tiles = [UIImage imageNamed:@"tiles.png"];
    
    UIImage *img = [self getSubImageFrom:tiles withRect:CGRectMake(location.x*tile_size_x, location.y*tile_size_y, tile_size_x, tile_size_y)];
    
    return img;
}

-(UIImage*)getSubImageFrom: (UIImage*) img withRect: (CGRect) rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

@end
