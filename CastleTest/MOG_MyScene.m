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

#define TILE_SIZE_X		16
#define TILE_SIZE_Y		16
#define GAME_VIEW_X		64
#define GAME_VIEW_Y		64
#define TILE_UNIT		2


#define T_WALL			1
#define T_WATER			2
#define T_LADDER_WALL	4
#define T_DOOR_WALL		8
#define T_PLAYER		16
#define T_WEAPON		32
#define T_ENEMY			64
#define T_LAVA		    128

#define T_NADA		    0
#define T_LADDER		2
#define T_WDOOR			10
#define T_STONE			20
#define T_BROKEN_STONE	30
#define T_KEYDOOR		40
#define T_EXPLOSION		50
#define T_DOOR			60
#define T_ITEM		    70
#define T_WEAPON_ARROW	80
#define T_ARMOUR		90
#define T_TOMB			100
#define T_WKEYDOOR		110
#define T_WNOKEYDOOR	120
#define T_WEAPON_ARROW2	130
#define T_FAIRY_BUBBLE	140
#define T_FAIRY			150
#define T_HITWALL		160
#define T_WNOKEYDOOR2	170
#define T_WEAPON_FIRE	180
#define T_WEAPON_MINE	190
#define T_MINE_EXP		200
#define T_RFL_ARROW		210
#define T_RFL_ARROW2	220
#define T_RFL_FIRE		230
#define T_WEAPON_RFIRE	240
#define T_RFL_RFIRE		250
#define T_WNOKEYDOOR3	260
#define T_PAMPERSE		270


#define T_WORM				1
#define T_BAT				2
#define T_SKELETON			3
#define T_SMOKE				4
#define T_SLIME				5
#define T_BOUNCINGBALL		6
#define T_WATERMONSTER		7
#define T_WATERMONSTER_ARM	8
#define T_BUBBLE			9
#define T_JUMPINGBUSH		10
#define T_BLUESPIDER		11
#define T_WHITEFIREBALL		12
#define T_FSTONE			13
#define T_RSTONE			14
#define T_KNIGHT			15
#define T_BLOB				16
#define T_BAMBU				17
#define T_PORCUPINE			18
#define T_PORCUPINE_BULLET	19
#define T_BLACK				20
#define T_WITCH				21
#define T_WHITEBEAR			22
#define T_WHITEBEAR_BULLET	23
#define T_FEET				24
#define T_REDJUMPER			25
#define T_VENT2				26
#define T_LIVINGWALL		27
#define T_MEGABAT			28
#define T_MEGABAT2			29
#define T_MEGABAT3			30
#define T_LAVA1				31
#define T_LAVA2				32
#define T_LAVA3				33
#define T_PIRANHA			34
#define T_PIRANHA2			35
#define T_WHITESTAR			36
#define T_SPIDER			37
#define T_KNIGHTHEAD		38
#define T_CHICKEN			39
#define T_CHICKEN_EGG		40
#define T_EGG_EXPLOSION		41
#define T_ROCKMAN			42
#define T_CLOUD				43
#define T_BFLY_SMALL		44
#define T_BFLY_MEDIUM		45
#define T_BFLY_LARGE		46
#define T_BFLY_GIANT		47
#define T_BFLY_BULLET		48
#define T_ARMOUR_ARROW		49
#define T_GHOST				50
#define T_GHOST_BULLET		51
#define T_HEAD				52
#define T_HEAD_BULLET		53
#define T_WORM2				54
#define T_OCTOPUS			55
#define T_HAIRY				56
#define T_HAIRYBULLET		57
#define T_WATERDRAGON		58
#define T_WATERBUG			59
#define T_BIRD				60
#define T_STONEMAN			61
#define T_STONEMAN_BULLET	62
#define T_PACMAN			63
#define T_REDDRAGON			64
#define T_REDDRAGON_BULLET	65
#define T_OWL				66
#define T_GREENMONKEY		67
#define T_PLANT				68
#define T_PLANT_BULLET		69
#define T_TRANSFORMER		70
#define T_TRANSF_BULLET		71
#define T_FLAME				72
#define T_FLAME_BULLET		73
#define T_WITCH2			74
#define T_CYCLOPS			75
#define T_CYCLOPS_BULLET	76
#define T_LCLOUD			77
#define T_LIGHTNING			78
#define T_LIGHTNING_FIRE	80
#define T_SNAKE				81
#define T_SNAKE_BULLET		82
#define T_GLIZARD			83
#define T_GLIZARD_TONGUE	84
#define T_GORILLA			85
#define T_GORILLA_ARM		86
#define T_BDEMON			87
#define T_BDEMON_BULLET		88
#define T_PAMPERSE_BALL		89

@interface MOG_MyScene()
-(void)loadRoom:(int)map atLocation:(CGPoint)xy;
@property (nonatomic, strong) NSMutableArray *tilesKey;
@property (nonatomic, strong) MOG_PlayerCharacter *playerCharacter;
@property int currentRoomX;
@property int currentRoomY;
@end

@implementation MOG_MyScene

@synthesize tilesKey = _tilesKey;
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
        self.currentRoomY = 4;
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
    int tileX = [[[self.tilesKey objectAtIndex:191] objectAtIndex:1] intValue];
    int tileY = [[[self.tilesKey objectAtIndex:191] objectAtIndex:2] intValue];
    int tileSizeX = [[[self.tilesKey objectAtIndex:191] objectAtIndex:3] intValue];
    int tileSizeY = [[[self.tilesKey objectAtIndex:191] objectAtIndex:4] intValue];
    
    // Add player sprite
    UIImage *playerImage = [self loadTile:CGPointMake(tileX, tileY) withSize:CGSizeMake(tileSizeX, tileSizeY)];
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

        for (int i = 0; i < numberOfObjects; i++) {
            NSString *objectInfo;
            [theScanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&objectInfo];
            NSLog(@"%@", objectInfo);
            NSArray *components = [objectInfo componentsSeparatedByString:@" "];
            int objectX;
            int objectY;
            if ([[components objectAtIndex:0] isEqualToString:@"ENEMY"]) {
                NSString *enemyType = [components objectAtIndex:1];
                objectX = [[components objectAtIndex:2] integerValue];
                objectY = [[components objectAtIndex:3] integerValue];
            } else {
                objectX = [[components objectAtIndex:1] integerValue];
                objectY = [[components objectAtIndex:2] integerValue];
            }
            
//            [theScanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&objectName];
//            if ([objectName co:@"ENEMY"]) {
//                NSString *enemyType;
//                [theScanner scanString:someString intoString:&enemyType];
//            }
//            int objectX;
//            int objectY;
//            int objectSize;
//            int objectState;
//            [theScanner scanInt:&objectX];
//            [theScanner scanInt:&objectY];
//            if ([objectName isEqualToString:@"LADDER"]) {
//                [theScanner scanInt:&objectSize];
//                [theScanner scanInt:&objectState];
//            }
//            if ([objectName isEqualToString:@"STONE"]) {
//                [theScanner scanInt:&objectState];
//            }
//            NSLog(@"%@", objectName);
        }
        
        int i = 0;
        CGSize offScreenSize = CGSizeMake(16 * roomSizeX, 16 * roomSizeY);
        UIGraphicsBeginImageContext(offScreenSize);
        
        for (NSNumber *tileNumber in roomTiles) {
            int tileXindex = [[[self.tilesKey objectAtIndex:tileNumber.intValue] objectAtIndex:1] intValue];
            int tileYindex = [[[self.tilesKey objectAtIndex:tileNumber.intValue] objectAtIndex:2] intValue];
            int tileSizeX =  [[[self.tilesKey objectAtIndex:tileNumber.intValue] objectAtIndex:3] intValue];
            int tileSizeY =  [[[self.tilesKey objectAtIndex:tileNumber.intValue] objectAtIndex:4] intValue];
            
            int roomX = i % roomSizeX;
            int roomY = i / roomSizeX;
            int tileType = [[[self.tilesKey objectAtIndex:tileNumber.intValue] objectAtIndex:7] intValue];
            if (tileType == T_WALL) {
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
            UIImage *tile = [self loadTile:CGPointMake(tileXindex, tileYindex) withSize:CGSizeMake(tileSizeX, tileSizeY)];
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
    
    self.tilesKey = [[NSMutableArray alloc] initWithCapacity:tileCount];
    
    for (NSString *row in rows) {
        NSArray* columns = [row componentsSeparatedByString:@","];
        [self.tilesKey addObject:columns];
    }
}

-(UIImage *)loadTile:(CGPoint)location withSize:(CGSize)size{
    int tile_size_x = 1;
    int tile_size_y = 1;
    
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
