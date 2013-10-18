//
//  MOG_PlayerCharacter.m
//  CastleTest
//
//  Created by Steven Christe on 10/15/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import "MOG_PlayerCharacter.h"

@implementation MOG_PlayerCharacter

@synthesize isJumping;
@synthesize hitPoints;
@synthesize experiencePoints;

- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position{
    self = [super initWithTexture:texture];
    if (self) {
        // init statements
        self.position = position;
        self.physicsBody.affectedByGravity = YES;
        self.physicsBody.mass = 10;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:texture.size];
        self.physicsBody.categoryBitMask = MOGColliderTypeHero;
        self.physicsBody.contactTestBitMask = MOGColliderTypeWall;
        self.isJumping = NO;
    }
    return self;
}

#pragma mark - Animation
- (void)resolveRequestedAnimation {
    // Determine the animation we want to play.
    NSString *animationKey = nil;
    NSArray *animationFrames = nil;
    MOGAnimationState animationState = self.requestedAnimation;
    
    switch (animationState) {
            
        default:
        case MOGAnimationStateIdle:
            animationKey = @"anim_idle";
            animationFrames = [self idleAnimationFrames];
            break;
            
        case MOGAnimationStateWalk:
            animationKey = @"anim_walk";
            animationFrames = [self walkAnimationFrames];
            break;
            
        case MOGAnimationStateAttack:
            animationKey = @"anim_attack";
            animationFrames = [self attackAnimationFrames];
            break;
            
        case MOGAnimationStateGetHit:
            animationKey = @"anim_gethit";
            animationFrames = [self getHitAnimationFrames];
            break;
            
        case MOGAnimationStateDeath:
            animationKey = @"anim_death";
            animationFrames = [self deathAnimationFrames];
            break;
    }
    
    //if (animationKey) {
    //    [self fireAnimationForState:animationState usingTextures:animationFrames withKey:animationKey];
    //}
    
    //self.requestedAnimation = self.dying ? MOGAnimationStateDeath : MOGAnimationStateIdle;
}


@end
