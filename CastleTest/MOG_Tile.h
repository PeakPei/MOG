//
//  MOG_Tile.h
//  CastleTest
//
//  Created by Steven Christe on 10/15/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOG_Tile : NSObject

@property (nonatomic, strong) UIImage *image;

- (id)init:(CGPoint)tileLocation;

@end
