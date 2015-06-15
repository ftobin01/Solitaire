//
//  cards.m
//  sol1
//
//  Created by Fergal Tobin on 23/03/2015.
//  Copyright (c) 2015 Fergal Tobin. All rights reserved.
//

#import "cards.h"
#include "constants.h"

@interface Card  (NSObject)

@property (nonatomic) int          cardSuit;
@property (nonatomic)   int        cardVal;
@property (nonatomic)   NSString  *cardPic;
@property (nonatomic)   bool      cardFaceUp;
@property (nonatomic)   CGRect    cardRect;


-(Card *) initCardWithData: (int ) suitNum :( int ) cardNumVal : (NSString *) cardPicName : (CGRect) cardRect : (BOOL ) cardFaceUp;


- (BOOL)  sameSuit   : (Card *) card1 : (Card *) card2;
- (BOOL) redAndBlack : (Card *) card1 : (Card *) card2;
- (BOOL) cardIsLower : (Card *) card1 : (Card *) card2;

@end




@implementation Card

- (id)init {
    if ((self = [super init])) {
        _cardSuit=0;
        _cardVal = 0;
        _cardPic = @"";
        _cardRect = CGRectMake(0,0,0,0);
        _cardFaceUp= @"";    }
    
    return self;
}

// CardShould be next in sequence - for droppping to Ace
-(BOOL) cardIsNext : (Card *) dropCard : (Card *) dragCard
{
    if ((dragCard.cardVal+1)==dragCard.cardVal)
        return(TRUE);
    
    return(FALSE);
    
    
    
}
- (BOOL)  cardIsLower : (Card *) card1 : (Card *) card2
{
    if ( card1.cardVal < card2.cardVal)
        return(TRUE);
    return (FALSE);
}




- (BOOL)  sameSuit : (Card *) card1 : (Card *) card2
{
    if ( card1.cardSuit == card2.cardSuit )
        return (TRUE);
    return(FALSE);
}


- (BOOL) redAndBlack : (Card *) card1 : (Card *) card2
{
    if (( (card1.cardSuit == HEARTS) || (card1.cardSuit == DIAMONDS )) && ((card2.cardSuit ==CLUBS)  || (card2.cardSuit == SPADES )))
        return (TRUE);
    
    if (((card1.cardSuit == SPADES ) || (card1.cardSuit == CLUBS )) && ((card2.cardSuit == HEARTS ) || (card2.cardSuit == SPADES )))
        return (TRUE);
    
    return (FALSE);
}

/*
 NSDictionary* defaults = @{kUserNameKey:@"GreatUser", kLevel1ScoreKey:@0, kLevel1CompletedKey:@NO};
 [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
 
 
 
 
 
 
 (id)initWithAccountID:(NSString *)identifier {
 
 if ( self = [super init] ) {
 
 Account *ac = [accountDictionary objectForKey:identifier];
 
 if (ac) { // object with that ID already exists
 
 [self release];
 
 return [ac retain];
 
 }
 
 if (identifier) {
 
 accountID = [identifier copy]; // accountID is instance variable
 
 [accountDictionary setObject:self forKey:identifier];
 
 return self;
 
 } else {
 
 [self release];
 
 return nil;
 
 }
 
 } else
 
 return nil;
 
 }
 
 
 
 
 */









-(Card *)initCardWithData : (int ) suitNum :( int ) cardNumVal : (NSString *) cardPicName : (CGRect) cardRect : (BOOL ) cardFaceUp
{
    if ((self = [super init])) {
        
        _cardSuit=  suitNum;
        _cardVal = cardNumVal;
        _cardPic = cardPicName;
        _cardRect = CGRectMake(0,0,0,0);
        _cardFaceUp= cardFaceUp;
    }
    return (self);
}








// view1 will be positioned at x = 30, y = 20 starting the top left corner of [self view]
// [self view] could be the view managed by a UIViewController


//makeCard()

//UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(30.0f, 20.0f, 400.0f, 400.0f)];
//view1.backgroundColor = [UIColor redColor];

//[[self view] addSubview:view1];




//[[UIColor blackColor] setFill];
//UIRectFill((CGRect){0,200,rect.size.width,1});



@end
