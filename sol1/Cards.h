//
//  Cards.h
//  sol1
//
//  Created by Fergal Tobin on 23/03/2015.
//  Copyright (c) 2015 Fergal Tobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "constants.h"

@interface Card : NSObject
@property (nonatomic) int          cardSuit;
@property (nonatomic)   int        cardVal;
@property (nonatomic)   NSString  *cardPic;
@property (nonatomic)   bool      cardFaceUp;
@property (nonatomic)   CGRect    cardRect;


-(Card *) initCardWithData : (int ) suitNum :( int ) cardNumVal : (NSString *) cardPicName : (CGRect) cardRect : (BOOL ) cardFaceUp;

- (BOOL)  sameSuit   : (Card *) card1 : (Card *) card2;
- (BOOL) redAndBlack : (Card *) card1 : (Card *) card2;
- (BOOL) cardIsLower : (Card *) card1 : (Card *) card2;


@end
