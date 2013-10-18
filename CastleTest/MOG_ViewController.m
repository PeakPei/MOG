//
//  MOG_ViewController.m
//  CastleTest
//
//  Created by Steven Christe on 10/13/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import "MOG_ViewController.h"
#import "MOG_MyScene.h"

@interface MOG_ViewController()
@end

@implementation MOG_ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    // Create and initialize a tap gesture
    //UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    //swipeRecognizer.numberOfTouchesRequired = 1;
    //swipeRecognizer.direction = (UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionUp);
    //[self.view addGestureRecognizer:swipeRecognizer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsDrawCount = YES;
        
        // Create and configure the scene.
        SKScene *scene = [MOG_MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        NSLog(@"%@", NSStringFromCGRect(scene.frame));
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// Respond to a swipe gesture

@end
