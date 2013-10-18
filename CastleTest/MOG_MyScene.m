//
//  MOG_MyScene.m
//  CastleTest
//
//  Created by Steven Christe on 10/13/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//
// Castle Map
// http://bifi.msxnet.org/msxnet/konami/mog/castle.png


#import "MOG_MyScene.h"
#import "MOG_PlayerCharacter.h"

@interface MOG_MyScene()
-(void)loadRoom:(int)map atLocation:(CGPoint)xy;
@property (nonatomic, strong) NSMutableArray *tilesX;
@property (nonatomic, strong) NSMutableArray *tilesY;
@property (nonatomic, strong) NSMutableArray *tilesType;
@property (nonatomic, strong) MOG_PlayerCharacter *playerCharacter;
@property int currentRoomX;
@property int currentRoomY;
@end

@implementation MOG_MyScene

@synthesize tilesX = _tilesX;
@synthesize tilesY = _tilesY;
@synthesize tilesType = _tilesType;
@synthesize count;
@synthesize playerCharacter = _playerCharacter;
@synthesize currentRoomX;
@synthesize currentRoomY;

#pragma mark - Initialization
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        self.count = 0;
        [self getTileKeys];

        self.currentRoomX = 0;
        self.currentRoomY = 15;
        /* Setup your scene here */
        [self buildWorld];
        
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
}

#pragma mark - World Building
- (void)buildWorld {
    NSLog(@"Building the world");
    
    // Configure physics for the world.
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f); // normal gravity
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    [self loadRoom:0 atLocation:CGPointMake(self.currentRoomX, self.currentRoomY)];
    int tileX = [[self.tilesX objectAtIndex:191] intValue];
    int tileY = [[self.tilesY objectAtIndex:191] intValue];
    
    // Add player sprite
    UIImage *playerImage = [self loadTile:CGPointMake(tileX, tileY) withSize:CGSizeMake(2, 2)];
    SKTexture *texture = [SKTexture textureWithImage:playerImage];
    texture.filteringMode = SKTextureFilteringNearest;
    self.playerCharacter = [[MOG_PlayerCharacter alloc] initWithTexture:texture atPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [self addChild:self.playerCharacter];
    
    //[self addBackgroundTiles];
    
    //[self addSpawnPoints];
    
    //[self addTrees];
    
    //[self addCollisionWalls];
}

#pragma mark - User Input
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        self.count++;
//    }
//}

- (IBAction)respondToSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    // Get the location of the gesture
    //CGPoint location = [recognizer locationInView:self.view];
    
    // If gesture is a left swipe, specify an end location
    // to the left of the current location
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"UP");
            self.currentRoomY++;
            [self loadRoom:0 atLocation:CGPointMake(self.currentRoomX, self.currentRoomY)];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"DOWN");
            self.currentRoomY--;
            [self loadRoom:0 atLocation:CGPointMake(self.currentRoomX, self.currentRoomY)];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"LEFT");
            self.currentRoomX--;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"RIGHT");
            self.currentRoomX++;
            break;
        default:
            break;
    }
    [self loadRoom:0 atLocation:CGPointMake(self.currentRoomX, self.currentRoomY)];
}


#pragma mark - Loop Update
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - Physics Delegate
- (void)didBeginContact:(SKPhysicsContact *)contact {
}

-(void)loadRoom:(int)map atLocation:(CGPoint)xy{
    [self removeAllChildren];
    
    NSArray *prefixes = [NSArray arrayWithObjects:@"map",@"w01",@"w02",@"w03",@"w04",@"w05",@"w06",@"w07",@"w08",@"w09",@"w10", nil];
    NSString *filename = [NSString stringWithFormat:@"%@%.2i%.2i", [prefixes objectAtIndex:map], (int)xy.x, (int)xy.y];
    
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *mapFilename = [myBundle pathForResource:filename ofType:@"txt"];
    if (mapFilename != nil) {
        
        NSLog(@"Loading data from room %@", mapFilename);
        NSData *data = [NSData dataWithContentsOfFile:mapFilename];
        NSString *someString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        int roomSizeX = 0;
        int roomSizeY = 0;
        NSScanner *theScanner = [NSScanner scannerWithString:someString];
        [theScanner scanInt:&roomSizeX];
        [theScanner scanInt:&roomSizeY];
        
        int value = 0;
        NSMutableArray *roomTiles = [NSMutableArray arrayWithCapacity:roomSizeX*roomSizeY];
        for (int i = 0; i < roomSizeX*roomSizeY; i++) {
            [theScanner scanInt:&value];
            [roomTiles addObject:[NSNumber numberWithInt:value]];
        }
        int numberOfObjects = 0;
        [theScanner scanInt:&numberOfObjects];
        NSMutableArray *roomObjects = [NSMutableArray arrayWithCapacity:numberOfObjects];
        for (int i = 0; i < numberOfObjects; i++) {
            
        }
        
        int tileSizeX = 16;
        int tileSizeY = 16;
        int i = 0;
        CGSize offScreenSize = CGSizeMake(tileSizeX * roomSizeX, tileSizeY * roomSizeY);
        UIGraphicsBeginImageContext(offScreenSize);
        
        for (NSNumber *tile in roomTiles) {
            int tileXindex = [[self.tilesX objectAtIndex:tile.intValue] intValue];
            int tileYindex = [[self.tilesY objectAtIndex:tile.intValue] intValue];
            int roomX = i % roomSizeX;
            int roomY = i / roomSizeX;
            NSString *tileType = [self.tilesType objectAtIndex:tile.intValue];
            if ([tileType rangeOfString:@"T_WALL"].location != NSNotFound) {
                SKSpriteNode *wall = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.size.width/roomSizeX, self.size.height/roomSizeY)];
                wall.alpha = 0.1;
                // why do i have to add one to roomY?! I don't know!
                wall.position = CGPointMake(roomX * wall.size.width, self.frame.size.height - (roomY+1) * wall.size.height);
                wall.anchorPoint = CGPointZero;
                wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(tileSizeX, tileSizeY)];
                wall.physicsBody.dynamic = NO;
                wall.physicsBody.categoryBitMask = MOGColliderTypeWall;
                wall.physicsBody.collisionBitMask = 0;
                [self addChild:wall];
            }
            UIImage *tile = [self loadTile:CGPointMake(tileXindex, tileYindex) withSize:CGSizeMake(1, 1)];
            CGRect rect = CGRectMake(tileSizeX*roomX, tileSizeY*roomY, tileSizeX, tileSizeY);
            [tile drawInRect:rect];
            i++;
        }
        UIImage *roomImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        SKTexture *texture = [SKTexture textureWithImage:roomImage];
        texture.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture size:self.frame.size];
        //sprite.position = CGPointZero;
        sprite.anchorPoint = CGPointZero;
        sprite.name = @"background";
        sprite.zPosition = -1;
        [self addChild:sprite];
    }
}

#pragma mark - Shared Assets
-(void)getTileKeys{
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *filename = [myBundle pathForResource:@"tilekey" ofType:@"txt"];
    
    NSData *data = [NSData dataWithContentsOfFile:filename];
    NSString *fileString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSArray *rows = [fileString componentsSeparatedByString:@"\n"];
    int tileCount = [rows count];
    
    self.tilesX = [[NSMutableArray alloc] initWithCapacity:tileCount];
    self.tilesY = [[NSMutableArray alloc] initWithCapacity:tileCount];
    self.tilesType = [[NSMutableArray alloc] initWithCapacity:tileCount];
    
    for (NSString *row in rows) {
        NSArray* columns = [row componentsSeparatedByString:@","];
        int x = [[columns objectAtIndex:0] intValue];
        int y = [[columns objectAtIndex:1] intValue];
        NSString *text = [columns objectAtIndex:4];
        
        [self.tilesX addObject:[NSNumber numberWithInt:x]];
        [self.tilesY addObject:[NSNumber numberWithInt:y]];
        [self.tilesType addObject:text];
    }
}

-(UIImage *)loadTile:(CGPoint)location withSize:(CGSize)size{
    int tile_size_x = 16;
    int tile_size_y = 16;
    
    UIImage *tiles = [UIImage imageNamed:@"tiles.png"];
    
    UIImage *img = [self getSubImageFrom:tiles withRect:CGRectMake(location.x*tile_size_x, location.y*tile_size_y, tile_size_x * size.width, tile_size_y    * size.height)];
    
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
