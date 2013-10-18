//
//  MOG_PlayerCharacter.h
//  CastleTest
//
//  Created by Steven Christe on 10/15/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : uint8_t {
    MOGColliderTypeHero             = 1,
    MOGColliderTypeEnemy            = 2,
    MOGColliderTypeProjectile       = 4,
    MOGColliderTypeWall             = 8,
    MOGColliderTypeOther            = 16
} MOGColliderType;

/* The different animation states of an animated character. */
typedef enum : uint8_t {
    MOGAnimationStateIdle = 0,
    MOGAnimationStateWalk,
    MOGAnimationStateAttack,
    MOGAnimationStateGetHit,
    MOGAnimationStateDeath,
    kAnimationStateCount
} MOGAnimationState;

#define kMovementSpeed 200.0

#define kCharacterCollisionRadius   40
#define kProjectileCollisionRadius  15

#define kDefaultNumberOfWalkFrames 28
#define kDefaultNumberOfIdleFrames 28

@interface MOG_PlayerCharacter : SKSpriteNode

@property BOOL isJumping;
@property NSUInteger hitPoints;
@property NSUInteger experiencePoints;
@property (nonatomic) MOGAnimationState requestedAnimation;

- (id)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;

/* Assets - should be overridden for animated characters. */
- (NSArray *)idleAnimationFrames;
- (NSArray *)walkAnimationFrames;
- (NSArray *)attackAnimationFrames;
- (NSArray *)getHitAnimationFrames;
- (NSArray *)deathAnimationFrames;

/* Loop Update - called once per frame. */
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

/* Orientation, Movement, and Attacking. */
- (void)move:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (CGFloat)faceTo:(CGPoint)position;
- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval;
- (void)moveInDirection:(CGPoint)direction withTimeInterval:(NSTimeInterval)timeInterval;
- (void)performAttackAction;

@end
