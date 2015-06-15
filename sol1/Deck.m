//
//  Deck.m
//  sol1
//
//  Created by F T on 25/05/2015.
//  Copyright (c) 2015 F T. All rights reserved.
//



#import "Deck.h"
#import "Card+View.h"
//#define CARDREVERSE     @"card reverse 2.jpeg"

@interface DeckObj (Card)


@property (nonatomic,strong) NSMutableArray *deck;

@property (nonatomic,strong) NSMutableArray   *cardsMainArea; //
@property(nonatomic,strong)  NSMutableArray   *cardsAceArea; //not sure i wil use this in Solitaire Screen
@property (nonatomic,strong) NSMutableArray   *deckShownArea; // where deck is shown

@property (nonatomic,strong) NSMutableArray   *clubsArea;
@property (nonatomic,strong) NSMutableArray   *heartsArea;
@property (nonatomic,strong)  NSMutableArray  *diamondsArea;
@property (nonatomic,strong) NSMutableArray   *spadesArea;
@property (nonatomic ) Card *cardInPlay;
@property (nonatomic,strong) NSMutableArray *cardsArray;
@property NSArray *suitWords;
@property NSArray *cardWords;

- (Card *) dealCard : (UIView *)dealView;
- (Card *)      getCardFromSubViewRect : (CGRect) aSubview;
- (Card *)      getCardFromRect : (NSMutableArray *) cardArray : (CGRect) aRect;
- (int ) maxVolIntersection : (NSMutableArray *) cardsToCheck : (CGRect) rectToChk;
- (void)        initDeck;


- (NSString *)  getPicFileName : (Card *) acard;
- (void) updateDeckShownArea : (Card*) dealtCard : (int) index;


//- (Card *)       initCardWithData : (int ) suitNum :( int ) cardNumVal : (NSString *) cardPicName : (CGRect) cardRect : (BOOL ) cardFaceUp;

- (BOOL) aceCardLogic : (Card *) dropCard :(Card *) dragCard;
- (BOOL) mainCardLogic :(Card *) dropCard :(Card *) dragCard;

@end


@implementation DeckObj


-(void) initDeck
{
    _suitWords = @[ @"hearts", @"spades", @"clubs", @"diamonds"];
    _cardWords = @[ @"jack",@"queen",@"king",@"ace"];
    
    [self makeDeck];
}



// Sets up the Deck of Card and the Areas theu will be Played to.
-(void) makeDeck
{
    
    // Deck *solDeck = [[Deck alloc] init];
    //Log(@"InMakeDeck");
    //Log(@"InMakeDeck CARDREVERSE= %@",CARDREVERSE);
    _deck = [[NSMutableArray  alloc] initWithCapacity:52];
    _cardsMainArea = [[NSMutableArray  alloc] initWithCapacity:52]; // Cards in Solitaire Screen
    _deckShownArea = [[NSMutableArray  alloc] initWithCapacity:52]; // Cards in Solitaire Screen     _clubsArea = [[NSMutableArray  alloc] initWithCapacity:52];;
    _heartsArea = [[NSMutableArray  alloc] initWithCapacity:52];;
    _diamondsArea = [[NSMutableArray  alloc] initWithCapacity:52];;
    _spadesArea = [[NSMutableArray  alloc] initWithCapacity:52];;
    _cardsArray= [[NSMutableArray  alloc] initWithCapacity:52];
    _cardInPlay = [[Card alloc] init];
    
    // Create Deck
    Card *tmpCard;
    for (int suitNum=0; suitNum<4; suitNum++)
    {
        for (int  cardNumVal=1;cardNumVal<= 13; cardNumVal++)
        {
            
            tmpCard = [[Card alloc ] initCardWithData : suitNum : cardNumVal :  CARDREVERSE: CGRectMake(0,0,0,0) :FALSE];
            
            tmpCard.cardPic =[self getPicFileName : tmpCard];
            // [Card copy];
            [_cardsArray addObject: tmpCard];
            
        }
        
    }
    // Shuffle Deck - Only Done At Start
    //Log(@"InMakeDeck - about to shuffle");
    for (int cardPos=0; cardPos < [_cardsArray count]; cardPos++)
    {
        int randInt = (arc4random() % ([_cardsArray count] - cardPos)) + cardPos;
        
        [_cardsArray exchangeObjectAtIndex:cardPos withObjectAtIndex:randInt];
    }
    
    //Log(@"InMakeDeck - _cardsArray.count 3 aftrshuffle = >> %lu",(unsigned long)[_cardsArray count]);
    // Using A Set to maintain Integrity of Deck
    // Not Essential for Solitaire - but gives 'Clean Deck'
    
    //Log(@"InMakeDeck - about to add toSet ");
    //Log(@"InMakeDeck - _cardsArray count = %lu ",(unsigned long)[_cardsArray count]);
    [self.deck  addObjectsFromArray: _cardsArray];
    
    for (Card * c in _cardsArray)
        
    {
        //Log(@"In MakeDeck card c.cardSuit %d c.cardVal = %d",c.cardSuit,c.cardVal);
    }
    
}

// UPdates Cards in Deck Cards shown Areas in Game

-(void) updateDeckShownArea : (Card*) dealtCard : (int) index
{
    // index used because dont knowif its 3 or 1 card area
    int countDeckArea = (int) [[self deckShownArea] count];
    // if the deck shown card is missing a card add it otherwise replace it.
    if (countDeckArea>index)
        [[self deckShownArea] replaceObjectAtIndex: index withObject: dealtCard] ;
    else
    {
        [[self deckShownArea] addObject : dealtCard];
    }
}


// Ace Slots not taken up with this suit already
-(BOOL) suitNotInSlots : (int ) suitNum : (NSInteger *) intArray
{
    for (int i=0;i<4;i++)
        if (suitNum == intArray[i])
            return TRUE;
    return(FALSE);
    
}



-(BOOL) cardIsAce : (Card *) chkCard
{
    if (chkCard.cardVal == ACE_CARDVAL)
        return(TRUE);
    return (FALSE);
}

-(void)updateAceArray : (Card *) dealtCard
{
    switch (dealtCard.cardSuit) {
        case HEARTS:
            [_heartsArea addObject : dealtCard];
            break;
        case SPADES:
            [_heartsArea addObject : dealtCard];
            break;
        case CLUBS:
            [_heartsArea addObject : dealtCard];
            break;
        case DIAMONDS:
            [_heartsArea addObject : dealtCard];
            break;
        default:
            //Log(@"UPdateAceArray: cardSuit ERROR");
            break;
    }
}

#define     EMPTY   -1
-(BOOL) updateAcesShownArea : (Card *) dealtCard :(int) index
{
    static NSInteger aceSlotUsed[] ={EMPTY,EMPTY,EMPTY,EMPTY};
    
    if ((aceSlotUsed[index]==(NSInteger ) EMPTY) && ([self cardIsAce:dealtCard]) && ([self suitNotInSlots :dealtCard.cardSuit:aceSlotUsed] ))
    {
        //set dealtcard Rect to acesAreaSlot rect
        [dealtCard drawCardPicture : ( [_cardsAceArea objectAtIndex : index]) : dealtCard.cardPic     ];
        aceSlotUsed[index] = dealtCard.cardSuit;
        [self updateAceArray : dealtCard];
        return TRUE;
    }
    else
        //if
    {
        // Check if dealtCard is valid for Dropping
        // find view.rect in aces shown area
        // use it to find rect in all ace areas
        // use this card to check value/suit of view CArd to card being dropeed
        //- get copy of card from space
        //- compare suits and value with card
        //- if OK
        //    - update appropriate card suit array
        //   [self updateAceArray : dealtCard];               return TRUE;
    }
    return FALSE;
}




-(Card *) dealCard : (UIView *)dealView
{
    //Log(@"In dealCard");
    // Card *cardDealt = [[Card alloc] init];
    
    
    // Using First Iteration in Loop to NSSet element
    Card *dealCard;  //needs to outside swcope for loop
    for (dealCard in _deck)
    {
        //Card *cardDealt = [[Card alloc] init];
        // *cardDealt = *dealCard;
        dealCard.cardRect = dealView.frame;
        //Log(@"In dealCard :  1 [%d] = %@",(int)i++,dealCard.cardPic);
        //Log(@"In dealCard : dealCard.cardVal 1.1 = %d",dealCard.cardVal);
        
        // cardDealt= dealCard ;
        //   //Log(@"In dealCard dealCard 2 = %@",dealCard);
        break;
    }
    
    if (dealCard)
        [_deck removeObject: dealCard];
    
    //Log(@"In dealCard : dealCard.cardVal 1.1 = %@",dealCard);
    return (dealCard);      //returns nil if empty
}



-(NSString *) getPicFileName : (Card *) aCard
{
    //  get card val from acard
    //  construct filename from it
    //Log(@"getPicFileName 1 cardVal = %d",aCard.cardVal);
    int wordIndex;
    NSString *tmpString;
    if ((aCard.cardVal <= 10) && (aCard.cardVal >1))
    {
        tmpString = [NSString stringWithFormat:@"%d_of_%@.png",(int) aCard.cardVal, [_suitWords objectAtIndex : aCard.cardSuit] ];
    }
    else
    {
        if (aCard.cardVal==1)  // ace
            aCard.cardVal=14;
        wordIndex = aCard.cardVal -11; // 11,12,13,14
        tmpString = [NSString stringWithFormat:@"%@_of_%@.png", [_cardWords objectAtIndex : wordIndex], _suitWords[aCard.cardSuit]];
        
    }
    //Log(@"getPicFileName  2 cardVal = %d",aCard.cardVal);
    
    //Log(@"getPicFileName  3 cardVal = %@",aCard.cardPic);
    
    aCard.cardPic = [tmpString copy] ;
    aCard.cardFaceUp = TRUE;
    
    //Log(@"getPicFileName  4 cardVal = %@",aCard.cardPic);
    return tmpString;
    
}


-(Card *) getCardFromSubViewRect : (CGRect) aRect
{
    //Log(@"getCardFomSubView aSubview.frame = %@  ",NSStringFromCGRect(aRect));
    //Log(@"getCardFromSubView count of deck = %lu", (unsigned long)[_deck count]);
    Card *c = [[Card alloc] init];
    for ( c in _deck)
    {
        //Log(@"getCardFromSubview c.cardVal =%d aRect = %@ cardRect =%@",c.cardVal,NSStringFromCGRect(aRect),NSStringFromCGRect(c.cardRect));
        
        if ( CGRectEqualToRect(aRect, c.cardRect))
        {
            //Log(@"getCardFomSubView Found Card : %d %@", c.cardVal, c.cardPic);
            return (c);
        }
        
    }
    //Log(@"getCardFomSubView Returning Nil ");
    return (nil);
    /*
     Frame A view's frame (CGRect) is the position of its rectangle in the superview's coordinate system. By default it starts at the top left.
     
     Bounds A view's bounds (CGRect) expresses a view rectangle in its own coordinate system.
     */
}


-(Card *) getCardFromRect : (NSMutableArray *) cardArray : (CGRect) aRect
{
    //Log(@"getCardFromRect  1: arect.frame = %@  ",NSStringFromCGRect(aRect));
    //Log(@"getCardFromRect  2: count of cardArray = %lu", (unsigned long)[cardArray count]);
    Card *c = [[Card alloc] init];
    for ( c in cardArray)
    {
        //Log(@"getCardFromRect 3: c.cardVal =%d aRect = %@ cardRect =%@",c.cardVal,NSStringFromCGRect(aRect),NSStringFromCGRect(c.cardRect));
        
        if ( CGRectEqualToRect(aRect, c.cardRect))
        {
            //Log(@"getCardFromRect Found Card 4: %d %@", c.cardVal, c.cardPic);
            return (c);
        }
        
    }
    //Log(@"getCardFromRect Returning Nil 5:");
    return (nil);
    /*
     Frame A view's frame (CGRect) is the position of its rectangle in the superview's coordinate system. By default it starts at the top left.
     
     Bounds A view's bounds (CGRect) expresses a view rectangle in its own coordinate system.
     */
}


#pragma mark   - Card Logic Routines

-(BOOL) aceCardLogic : (Card *) dropCard :(Card *) dragCard
{
    if (![_cardInPlay sameSuit :dropCard : dragCard] )
        return (FALSE);
    if (![_cardInPlay cardIsLower : dropCard : dragCard])
        return(FALSE);
    
    return (TRUE);
}


-(BOOL) mainCardLogic :(Card *) dropCard :(Card *) dragCard
{
    if (![_cardInPlay redAndBlack: dropCard :dragCard])
        return (FALSE);
    if (![_cardInPlay cardIsLower:dragCard :dropCard])
        return (FALSE);
    
    return (TRUE);
}





-(int ) maxVolIntersection : (NSMutableArray *) cardsToCheck : (CGRect) rectToChk
{
    int maxVol=0;
    CGRect intVol;
    int maxVolIndex=0;
    for (int i=0; i<[cardsToCheck count]; i++)
    {
        Card   *checkCard = [cardsToCheck objectAtIndex : i];
        CGRect viewRect = checkCard.cardRect;
        CGRect intersectVolRect=CGRectIntersection(rectToChk,viewRect);
        if (!CGRectIsNull(intVol))
            // ! CGRectNull - they Intersect index to Card Array returned
        {
            // calculate Volume of Card
            int intersectVol = intersectVolRect.size.height * intersectVolRect.size.width;
            
            // if Greater Save the Index
            if (intersectVol > maxVol)
            {
                maxVol=intersectVol;
                maxVolIndex = i;
            }
        }
    }
    return(maxVolIndex);
}




NSComparisonResult compare(UIView *firstView, UIView *secondView, void *context)
{
    if ( firstView.frame.origin.y < secondView.frame.origin.y)
        return NSOrderedAscending;
    else if (firstView.frame.origin.y > secondView.frame.origin.y)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


-(NSMutableArray *) combineArrays :(NSMutableArray *) array1 : (NSMutableArray *) array2 : (NSMutableArray *) array3 : (NSMutableArray *) array4

{
    
    //This is to cumbersome and may give unpredictable results if nil ...
    // need  to be rewritten using safer logic or methods.
    //  some this like combine 2 at a time if not nil - or recursive rroutine.
    if (array1!=nil)
    {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:[array1 arrayByAddingObjectsFromArray:array2]];
        
        
        NSMutableArray *newArray2 = [NSMutableArray arrayWithArray:[newArray arrayByAddingObjectsFromArray:array3]];
        
        NSMutableArray *newArray3 = [NSMutableArray arrayWithArray:[newArray2 arrayByAddingObjectsFromArray:array4]];
        return (newArray3);
    }
    else
    {
        NSLog(@"Error: 1st Array Passed to combine Arrays is nil");
        return( nil); // nil
    }
}



@end
