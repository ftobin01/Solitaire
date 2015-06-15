//
//  UIViewHelp.h
//  sol1
//
//  Created by F T on 11/04/2015.
//  Copyright (c) 2015 F T. All rights reserved.
//

#ifndef sol1_UIViewHelp_h
#define sol1_UIViewHelp_h

@interface UIView (UIViewHelper)


-(UIView *) findTopMostViewForPoint : (CGPoint) point;


@property (strong, nonatomic) UIWindow *window;

@end

#endif
