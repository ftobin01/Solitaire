//
//  Card+View.m
//  sol1
//
//  Created by F T on 13/06/2015.
//  Copyright (c) 2015 F T. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "Card+View.h"

//@interface  Card

//-(UIImage *) drawCardPicture : (UIView *)  view1 : (NSString *)cardPicName;
//-(UIImage *) drawCardPicture : (UIView *)  view1 : (NSString *)cardPicName
//@end

@implementation Card (View)






-(UIImage *) drawCardPicture : (UIView *)  view1 : (NSString *)cardPicName
{
    /* sizes image to card view */
    
    UIImage *globalCardImage = [[UIImage alloc] init];
    //Log(@"drawCardPicture 1. PicName=%@",cardPicName);
    
    UIGraphicsBeginImageContext(view1.frame.size);
    [[UIImage imageNamed: cardPicName] drawInRect:view1.bounds];
    //Log(@"drawCardPicture 2. PicName=%@",cardPicName);
    globalCardImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Log(@"drawCardPicture 3. PicName=%@",cardPicName);
    view1.backgroundColor = [UIColor colorWithPatternImage:globalCardImage ];
    //view1.backgroundColor = [UIColor colorWithWhite:.5f alpha: .5f];
    
    //else if you want it to be another color use the general UIColor method: +colorWithRed:green:blue:alpha:    ];
    //Log(@"Leaving drawCardPicture 4. PicName=%@",cardPicName);
    
    return (globalCardImage);
    
}


-  (UIImage *)  imageTint :(NSString *) name withTintColor: (UIColor *) tintColor
{
    
    UIImage *baseImage = [UIImage imageNamed:name];
    
    CGRect drawRect = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(baseImage.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, baseImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // draw original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, drawRect, baseImage.CGImage);
    
    // draw color atop
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextFillRect(context, drawRect);
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}







@end
