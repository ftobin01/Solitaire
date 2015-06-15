//
//  MovingCards.h
//  sol1
//
//  Created by F T on 30/05/2015.
//  Copyright (c) 2015 F T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovingCards : UIGestureRecognizer


- (void)dragDetected: (UIPanGestureRecognizer *)panGestureRecognizer;

@end
