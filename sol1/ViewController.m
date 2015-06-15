//
//  ViewController.m
//  sol1
//
//  Created by Fergal Tobin on 23/03/2015.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//
//
// Programming Notes
//
// Found Solitaire is  challenging to program in the time given.
// Again it would have been nice to have it fully working - but so much to do in so little time.
// Games is working to the point where cards are moving about,
// being dropped, Deck is being updated. game logic has been written
// and partially impelemented. Time is the factor.
//
// Core Data - I went ahead and loaded up all the routines necessary for core Data - and - the result was just a monster of a project with basically a mountain of unmaintainable code - so in the interest of sanity - took it out and implemented a simple save of an integer representing High Score instead using NSUserDefaults. At least that way i will open this project again. Without a tableview - i don't think Core Data worth the effort.
//
// Deck Area was fully working for dragging and dropping - except to aces area- seemed to have knocked it out of shape yesterday trying to get the Aces Area to work!
//
// Dropping Cards from Main Area to Main Area works most of the time
// with some bugs - card logic routines have been written and half tested but felt these bugs need to be remmved before implementing further.
//
// Left To Do
//
// Deck Cards working again for dropping to main area
// Dropping to Aces Are from Main Area or Deck Area working
// End of Game animation -  code finished  and tested
// High Score - is half implemented including save data routines - but could prob display on screen and test being updated.
// With more time I believe I could have finished it in full.

// Thanks for all  help in getting me this to the point of being able to even attempt this which I couldnt have done last Sept. Of course all errors and omissions are mine!
//
// FT 15/6/2015

#import "ViewController.h"
#import "Deck.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Helper.h"
#include "constants.h"
#import "Card+View.h"
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dragAreas;
@property (nonatomic, strong) NSMutableArray *dropAreas;
@property (nonatomic, strong) NSArray *subviews;
@property (nonatomic, strong) UIImage *globalCardImage;
@property (nonatomic, strong) Card    *cardInPlay;
@property (nonatomic) UILabel *gameTimerLabel;

// Sinks for Cards
@property (nonatomic,strong) DeckObj *Deck;

-(void)  showDeck;
//-(CGRect ) inSubViewList : ( CGPoint ) locationInView;
//-( void ) drawCardPicture : (UIView *)  view1 : (NSString *)cardPicName;
-(CGRect )chkAreaByRect : (NSArray *) viewArea : ( CGRect ) locationRect;
//-(Card *) getCardFromSubView : (CGRect *) aRect;
//- (void) deleteSubViewByRect : (CGRect ) aRect;

@end


@implementation ViewController

//- (IBAction)tapDetected:(id)sender {
//}
static NSInteger highScore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    static bool done=FALSE;
        {
        _Deck = [[DeckObj alloc] init];
        [_Deck  initDeck];
        done=TRUE;
        }
    [self setupAllView];
    // Create Main Card Area
    [self makeMainCardLayout];
    // Create Aces Area
     [self createAcesArea];
     //Create Deck Area
     [self createDeckArea];
     //Log(@"viewDidLoad 7");
     // Start Game Timer
    [self makeGameTimerLabel];
     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameTime) userInfo:nil repeats:YES];
}



#pragma mark  - Card / View checking Routines



- (CGRect ) inDropViewList: ( CGPoint ) locationInView
    {
   //  NSArray *subviews = _dragAreas;
        
      //  [_dropAreas  addObjectsFropmArray : _dragAreas];
       // NSArray *deckAreaCards = [[_Deck deckShownArea] copy];
      //  [_dropAreas removeObjectsInArray: deckAreaCards];
    
        
        int dropViewCount =(int)  [_dropAreas count];
        //Log(@"InDropViewList...dropViewCount =%d",dropViewCount);
        UIView *subview = [[UIView alloc] init];
        
        if (dropViewCount >0)
            {
            for (int  subview_index = dropViewCount-1; subview_index >0; subview_index--)
                {
                subview = [_dropAreas objectAtIndex:subview_index];
                CGRect viewRect =  [subview frame];
                if (CGRectContainsPoint(viewRect, locationInView)==TRUE)
                    {
                //Log(@"InDropViewList...return subview");
                return(viewRect);
                    }
                }
            }
        //Log(@"InDropViewList...return nil");
        //viewRect =;
        return ( CGRectMake(0,0,0,0));
    }


- (CGRect ) inDragViewList: ( CGPoint ) locationInView
{
    //  NSArray *subviews = _dragAreas;
    int dragViewCount =(int)  [_dragAreas count];
    //Log(@"inDragViewList...");
    UIView *subview = [[UIView alloc] init];
    if (dragViewCount >0)
        {
            for (int  subview_index = dragViewCount-1; subview_index >0; subview_index--)
                {
                subview = [_dragAreas objectAtIndex:subview_index];
                CGRect viewRect =  [subview frame];
                if (CGRectContainsPoint(viewRect, locationInView)==TRUE)
                    {
                    //Log(@"inDragViewList...return subview");
                    return(viewRect);
                    }
                }
    }
    //Log(@"inDragViewList...return nil");
    //viewRect =;
    return ( CGRectMake(0,0,0,0));
}




- (CGRect ) chkAreaByPoint : (NSArray *) viewArea : ( CGPoint ) locationInView
{
    //  NSArray *subviews = _dragAreas;
    int viewCount = (int)  [viewArea count];
    //Log(@"chkViewByPoint...");
    UIView *view1 = [[UIView alloc] init];
    for (int  viewIdx = viewCount-1;  viewIdx >=0; viewIdx--)
    {
        view1 = [viewArea objectAtIndex:viewIdx];
        CGRect viewRect =  [view1 frame];
        if (CGRectContainsPoint(viewRect,locationInView)==TRUE)
        {
            //Log(@"chkAreaByPoint...returning Rect");
            return(viewRect);
        }
    }
    //Log(@"chkAreaByPoint...return nil");
    //viewRect =;
    return ( CGRectMake(0,0,0,0));
}




-(CGRect ) chkAreaByRect : (NSMutableArray *) viewArea : ( CGRect ) locationRect
{
    //Log(@"chkAreaByRect...0");    //  NSArray *subviews = _dragAreas;
    int viewCount = (int)  [viewArea count];
    //Log(@"chkAreaByRect...1");
    Card *view1 = [[Card alloc] init];
    //Log(@"chkAreaByRect...2");
    for (int  viewIdx = viewCount-1;  viewIdx >=0; viewIdx--)
    {
        //Log(@"chkAreaByRect...3");
        view1 = [viewArea objectAtIndex:viewIdx];
        //Log(@"chkAreaByRect...4") ;
        CGRect viewRect =  view1.cardRect;
        if (CGRectEqualToRect(viewRect, locationRect)==TRUE)
        {
            //Log(@"chkAreaByRect...returning Rect: TRUE");
            return(viewRect);
        }
    }
    //Log(@"chkAreaByRect...return nil FALSE");
    //viewRect =;
    return ( CGRectMake(0,0,0,0));
}

#pragma mark    - Tap and Gesture Routines


// Tap is for Deck Card on Screen
- (void)tapDetected: (UIGestureRecognizer *)tapGestureRecognizer
{
    //Log(@"In Tap Detected")
    CGPoint locationInView = [tapGestureRecognizer locationInView:self.view];
    CGRect tmpDeckRect = CGRectMake(DECKCARD_XPOS, DECKCARD_YPOS, CARDWIDTH,CARDLENGTH);
    if (CGRectContainsPoint(tmpDeckRect, locationInView))
    {
        //Log(@"Deck Pressed!!!!");
        [self showDeck];
    }
    switch (tapGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            //Log(@"Tap |Recognised");
            break;
        }
        case UIGestureRecognizerStateChanged:
            //Log(@"Tap |Recognised 2");
            break;
        case UIGestureRecognizerStateEnded:
            //Log(@"Tap |Recognised 3");
            break;
        default:
            //Log(@"Error - Gesture State Not Recognised 4");
            break;
    }
}


// This is for All Cards that can be Dragged
- (void)dragDetected: (UIPanGestureRecognizer *)panGestureRecognizer
{
    //Log(@"Drag Dectected 0 ");
    NSArray *subviews = [self.view subviews];
    CGPoint locationInView = [panGestureRecognizer locationInView:self.view];
    float x = locationInView.x;
    float y = locationInView.y;
    static float   dragCardOriginX;
    static float   dragCardOriginY;
    static int countStartingSubviews=0;
    dragCardOriginX=0; // viewRect.origin.x;
    dragCardOriginY=0; //  viewRect.origin.y;
    CGRect rectInView=CGRectZero;
    //Log(@"In DragDetected ");
    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:   //Drag Started
        {
            //Find Card from Drag Location
            rectInView =[self  inDragViewList :locationInView];
            if (CGRectIsEmpty(rectInView) )
            {
                //Log(@"Drag Detected - But Not Drag Area");
                panGestureRecognizer.enabled = NO;
                break;
            }
            else
                {
                // find Card Area to get card from - Add All Aces Area Together
               // NSMutableArray   *allAceAreas = [[NSMutableArray initWithCapacity : 52];
         //       [_Deck combineArrays : [_Deck clubsArea] :[_Deck heartsArea] :  [_Deck spadesArea] : [_Deck diamondsArea]];
                if (! (_cardInPlay= [_Deck getCardFromRect :[_Deck cardsMainArea] :rectInView]))
                {
                        if (!(_cardInPlay=[_Deck getCardFromRect: [_Deck deckShownArea] :rectInView ]))
                            ;
//TODO: finish CArd logic
                        //if ((_cardInPlay=[self getCardFromRect [_Deck acesArea] : rectInView]))
                            //Log(@"*** ACES AREA DETECTED ****");
                        //else
                        //Log(@"ERROR - CARD NOTFOUND ANYWHERE");
                    
                }
                countStartingSubviews=(int) [subviews count];
                dragCardOriginX = x -10;//+  ((dragCardOriginX
                dragCardOriginY = y -11; //+  ((dragCardOriginY
            }
        }

            break;
        case UIGestureRecognizerStateChanged:
        {//While Dragging
            dragCardOriginX = x -5;//
            dragCardOriginY = y -5; //
            // find card to drag
            [self makeDragCardView : dragCardOriginX : dragCardOriginY];
        }
            break;
        case UIGestureRecognizerStateEnded:    //Dropped!!!!!  - Dragging Ended
        {
            //drop Area = Drag Area- Deck Area
            //Delete Tails
            [self deleteSubViewTails :countStartingSubviews ];
            CGPoint dropLocationInView = [panGestureRecognizer locationInView:self.view];
/*Search Draggable Area */
            CGRect dropRectInView =[self  inDropViewList :dropLocationInView];
            //Log(@"dropLocationInView =%@ ",NSStringFromCGRect(dropRectInView));
            //Log(@"About to Check Drop  Area");
            
            if (CGRectIsEmpty(dropRectInView) )
            {
                //Log(@"Drop Area - Not Droppable ");
                //panGestureRecognizer.enabled = NO;
                break;
            }
            else
                {
                // Find Specific Area to Drop To
                // Check Main Area
                //Log(@"About to check if  Drop is in Main Area");
                    if (!CGRectIsEmpty ([self chkAreaByRect :_Deck.cardsMainArea :dropRectInView  ]))
                    {
            int mainCardIndex=[_Deck maxVolIntersection : _Deck.cardsMainArea : dropRectInView ];
            Card *cardDroppingOn= [[Card alloc] init];
            cardDroppingOn = [_Deck.cardsMainArea objectAtIndex : mainCardIndex];
                        //Log(@"Card with Biggest Volume = %d , cardSuit %d",cardDroppingOn.cardVal,cardDroppingOn.cardSuit);
                   // Main Area to Main Area
/****                [self moveToColumnByRect : dropRectInView : cardDroppingOn.cardRect];
                      - Add to end of Main Area
                        - search  for rect in cardsMain
                        - make new  from it
                        - change new card from reverse to Face UP
*/
                    // Deck Area to Main Area
            // Check Card Logic - if OK AddCard to View
      UIView *newView = [self addNewCardView :  _cardInPlay : cardDroppingOn];
        _cardInPlay.cardRect=newView.frame;
            [[_Deck cardsMainArea] addObject:_cardInPlay];
                [self updateDeckArea ];
                    }
                else
                    {
                        //Log(@"Drop Area not Main Area");
                    if (!CGRectIsEmpty ([self chkAreaByRect :_Deck.cardsAceArea :dropRectInView  ]))
                        {
                            // Card not in Main or in Deck so must be in aCes
int mainCardIndex=[_Deck maxVolIntersection : _Deck.cardsMainArea : dropRectInView ];
                        //Log(@"Drop in Aces Area");
                        }
                    // Dropable CArd Either from Deck or Main
                        /*
For both cases - Add cArd to Aces Area ;updateAcesArea ;if first card in AcesArea- update Draggable Areas
if card is from main; -update main area
     if (!CGRectIsEmpty ([self chkAreaByRect :_Deck.cardsAceArea :_cardInPlay.cardRect ]))
                        - add Card to Aces Are
                         if Card is from Deck - update Deckarea
                        */
                    }
                }
        }
            break;
        default:
            //Log(@"Error - Gesture State Not Recognised ");
            break;
        }
            if (panGestureRecognizer.state ==UIGestureRecognizerStateCancelled)
                panGestureRecognizer.enabled = YES;
            [self.view setNeedsDisplay];
}


    
#pragma mark -  Card/View Display Update Routines


// Routine assuming a card has been dropped from the Deck Area
-(void)updateDeckArea
{
    int count = (int)[_Deck.deckShownArea count];
    if (count >0) // If Cards In Deck
        {
            // Take Card frm Top of Deck
            Card *deckCard = [[_Deck deckShownArea]objectAtIndexedSubscript: count -1 ];
            // Remove Dropped  Card from Deck Shown Area
            [_Deck.deckShownArea removeLastObject];
            // Delete the View connected to it
            [self deleteSubviewByRect : deckCard.cardRect];
            // this will usually leave 2 views left
            if (count-2 >= 0 ) // if at least 2 cards - left make the second view the draggable one.
                {
            Card *newDeckCard = [[_Deck deckShownArea] objectAtIndexedSubscript: count -2 ];
                UIView *newDeckView = [self findViewByRect : newDeckCard.cardRect ];
                [self updateDragArea: deckCard :newDeckView];
                }
            else
                
                if (count ==1) //- 1 card left in Deck Shown Area
                { // find
            Card *newDeckCard = [[_Deck deckShownArea] objectAtIndexedSubscript: 1];
            UIView *newDeckView = [self findViewByRect : newDeckCard.cardRect ];
            [self updateDragArea: deckCard :newDeckView];
                }
            
        }
}

                                     
                                     
                                     
                                     
-(void)updateDropArea : (Card*) oldCard : (UIView*) newView
{
    UIView *oldViewFound = [self findViewByRect : oldCard.cardRect];
    //if (oldViewFound!=nil)
      //  {
        [_dropAreas removeObjectIdenticalTo: oldViewFound];
        [_dropAreas addObject : newView];
        //}
    //else
      //  //Log(@"Error : view not found : Drop Area");

}

-(void)updateDragArea : (Card*) oldCard : (UIView*) newView
{
     UIView *oldViewFound = [self findViewByRect : oldCard.cardRect];
   // if (oldViewFound!=nil)
     //   {
        [_dragAreas removeObjectIdenticalTo: oldViewFound];
        [_dragAreas addObject : newView];
       // }
   // else
     //   //Log(@"Error : view not found : Drag Area");
}



-(UIView *) updateSuperView : (CGRect ) viewRect
{
    UIView* v;
    for (v  in [self.view subviews])
    {
        if (CGRectEqualToRect(v.frame,viewRect))
            [v removeFromSuperview];
    }
    return (v);
}



                    
                     
-(void) deleteSubViewTails : (int)countStartingSubviews
{
    NSArray *subviews = [self.view subviews];
    
    unsigned long CurrentSubviewCount = [subviews count];
    //Log(@"DROPPED : CurrentSubviewCount = %lu,CountofStartingSubviews= %d",CurrentSubviewCount ,countStartingSubviews);
    
    for (int  i=(int) CurrentSubviewCount-(int)1 ; i>= (int) countStartingSubviews; i--)
    {
        UIView *subview = [subviews objectAtIndex:i];
        [subview removeFromSuperview];
        //[NSThread sleepForTimeInterval:0.6];
    }
}



                                     
                                     
-(UIView *) addNewCardView : (Card*) oldCard : (Card*) cardBeingAddedTo
{
    
    //Log(@"addNewCardView : oldCard = %@",oldCard);
    float newXPos = cardBeingAddedTo.cardRect.origin.x;
    float newYPos = cardBeingAddedTo.cardRect.origin.y+CARDLENGTH/2;
    CGRect newRect = CGRectMake(newXPos,newYPos,  CARDWIDTH, CARDLENGTH);
    UIView *newView =[[UIView alloc] initWithFrame: newRect];
   
      [oldCard drawCardPicture : newView : oldCard.cardPic ];
      [[self view] addSubview:newView];
   // [self updateSuperView:oldCard.cardRect] ;
    
    [self updateDragArea:oldCard : newView];
    [self updateDropArea:oldCard :newView];
    //oldCard.cardRect = newRect; // Update Card
    
    return (newView);
}

    


-(void) makeDragCardView: (float) dragCardOriginX :(float) dragCardOriginY
{
    
    //Log(@"in makeTmpCardView..\7dragCardOriginX %f,dragCardOriginY %f ",dragCardOriginX,dragCardOriginY);
    
    CGRect tmpRect=CGRectMake( dragCardOriginX,dragCardOriginY , CARDWIDTH, CARDLENGTH) ;
       UIView *tmpView = [[UIView alloc] initWithFrame: tmpRect];
    
    //   tmpView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: _cardInPlay.cardPic] ];
    
    
    [_cardInPlay drawCardPicture :  tmpView : _cardInPlay.cardPic];
    
    
    [self.view addSubview: tmpView];
    [self.view setNeedsDisplay];
    
    
}
 
#pragma mark - Routines Driven by  Rect Values



-(void) moveToColumnByRect : (CGRect ) origRect : (CGRect ) dropRect
{
    // This method sorts the rects coord by ypos in Array tomake sure they arein order before a move. it then moves all card above certain y value to simulate a column move.
    
    // Copy Subview Array
    NSMutableArray *subviewCopy= [NSMutableArray arrayWithArray :self.view.subviews];
    // Sort it usingCol Position
    NSArray *sortedViews = [subviewCopy sortedArrayUsingComparator: ^NSComparisonResult(UIView *obj1, UIView *obj2) {
                            if (obj1.frame.origin.y < obj2.frame.origin.y) {
                                return NSOrderedAscending;
                            } else if (obj1.frame.origin.y  > obj2.frame.origin.y) {
                                return NSOrderedDescending;
                            } else {
                                return NSOrderedSame;
                            }
                        }
                            ];

   
    // update dropRect Pos by card gap // will need to global variable or global object variable
    //for (UIView * view1 in  sortedViews) // find all subviews in column
    
 //   find all rects with same x (column )
 //   - find all rects with yvalu same and greater
 //   - update - update xand  and ypos by offset of rect dropping + new
    
        for (int i=0; i<[sortedViews count]; i++)
        {
            // subviews ***
      UIView *view1 = [sortedViews objectAtIndex:i];
        if (origRect.origin.y == view1.frame.origin.y)  // FindViews with Orig ColSize
            {
                ;  // create Copy of origrect
                CGRect newRect = CGRectMake(dropRect.origin.x, dropRect.origin.x +CARDOVERLAYGAP, origRect.size.height,origRect.size.width );
                _cardInPlay=[_Deck getCardFromRect :  [_Deck cardsMainArea] :  origRect];
                 
                 UIView *newView = [[UIView alloc] initWithFrame: newRect];
                newView.backgroundColor = [UIColor orangeColor];
                // need to do Card processing! also
                [self.view  addSubview: newView];
                [_cardInPlay drawCardPicture : newView : _cardInPlay.cardPic];
                [self deleteSubviewByRect : origRect ];
                
            }
        }
                        
}
                            
                            
- (UIView *) deleteSubviewByRect : (CGRect ) aRect
    {
        UIView *view1;
    for (int i=0; i<[self.view.subviews count]; i++)
        {
       view1 = [self.view.subviews objectAtIndex:i];
        if (CGRectEqualToRect(aRect, view1.frame))
            [view1 removeFromSuperview];
        }
        return (view1);
    }
                            
                            
    
- (void)didReceiveMemoryWarning
        {
            [super didReceiveMemoryWarning];
            // Dispose of any resources that can be recreated.
        }



-(UIView *) findViewByRect : (CGRect ) viewRect
{
    UIView* v;
    for (v  in [self.view subviews])
    {
        if (CGRectEqualToRect(v.frame,viewRect))
            break;
    }
    return (v);
}



#pragma mark - Game Timer Routines


-(void)gameTime
{
    static int gtime = 1;
    int seconds = gtime % 60;
    int minutes = (gtime / 60) % 60;
    int hours = gtime / 3600;
    _gameTimerLabel.text = [NSString stringWithFormat:@" %02d:%02d:%02d ",hours,minutes,seconds];
    gtime++;
}

-(void)makeGameTimerLabel
{
    _gameTimerLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 195, 80, 80)];//Set frame of label
    [_gameTimerLabel setBackgroundColor: TIMER_COLOR];//Set background color of label.
    [_gameTimerLabel setText:@"game on"];//Set text in label.
    [_gameTimerLabel setTextColor:[UIColor blackColor]];//Set text color in label.
    [_gameTimerLabel setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [_gameTimerLabel setAdjustsFontSizeToFitWidth:YES];
    [_gameTimerLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [_gameTimerLabel setLineBreakMode:NSLineBreakByClipping];//Set linebreaking mode..
    [_gameTimerLabel setNumberOfLines:1];//Set number of lines in label.
    [_gameTimerLabel.layer setCornerRadius:25.0];//Set corner radius of label to change the shape.
    [_gameTimerLabel.layer setBorderWidth:2.0f];//Set border width of label.
    [_gameTimerLabel setClipsToBounds:YES];//Set its to YES for Corner radius to work.
    [_gameTimerLabel.layer setBorderColor:[UIColor blackColor].CGColor];//Set Border color.
    [self.view addSubview:_gameTimerLabel];//Add it to the view of your choice.
}








#pragma mark  - Game Display Setup Routines



-(void) showDeck
{
    if ([[_Deck deck ] count] ==0)
        return; // DEck Empty!
    static BOOL SHOW_3_CARDS= TRUE;
    static BOOL DECK_SHOWN=FALSE;
    static UIView *showCard1;   //change to show card view
    static UIView *showCard2;
    static UIView *showCard3;
    int countDeckArea=(int) [[_Deck deckShownArea] count];
    if (countDeckArea==0)
        DECK_SHOWN=FALSE;
    if (!DECK_SHOWN)
        // need at least 1 view
    {
        //Log(@"calling showDeck");
        CGRect cardRect1 = CGRectMake( SHOWDECK_XPOS, DECKCARD_YPOS, CARDWIDTH, CARDLENGTH);
        showCard1 = [[UIView alloc] initWithFrame:cardRect1];
        Card *dealtCard1= [_Deck dealCard : showCard1];
        [dealtCard1 drawCardPicture : showCard1  : dealtCard1.cardPic];
        [self.view addSubview: showCard1];
        [[_Deck deckShownArea] addObject: dealtCard1];
        
        if (SHOW_3_CARDS==TRUE)
        {
            
            CGRect cardRect2 = CGRectMake( SHOWDECK_XPOS+10, DECKCARD_YPOS, CARDWIDTH, CARDLENGTH);
            showCard2=[[UIView alloc] initWithFrame:cardRect2];
            Card *dealtCard2= [_Deck dealCard : showCard2];
            if ( dealtCard2  !=nil)
            {
                
                [self.view addSubview: showCard2];
                Card *dealtCard2= [_Deck dealCard : showCard2];
                
                [dealtCard2 drawCardPicture : showCard2  : dealtCard2.cardPic];
                //Log(@"showDeck: adding dealtCard2.cardPic =%@",dealtCard2.cardPic);
                [[_Deck deckShownArea] addObject: dealtCard2];
                [_dragAreas removeLastObject];
                [_dragAreas addObject: showCard2];
                
                CGRect cardRect3 = CGRectMake( SHOWDECK_XPOS+20, DECKCARD_YPOS, CARDWIDTH, CARDLENGTH);
                showCard3=[[UIView alloc] initWithFrame:cardRect3];
                Card *dealtCard3= [_Deck dealCard : showCard3];
                if ( dealtCard3  !=nil)
                {
                    [dealtCard3 drawCardPicture : showCard3  : dealtCard3.cardPic];
                    //Log(@"showDeck: adding dealtCard3.cardPic =%@",dealtCard2.cardPic);                                    [[_Deck deckShownArea] addObject: dealtCard3];
                    //Log(@"showDeck: after adding dealtCard2.cardPic =%@",[[_Deck deckShownArea] objectAtIndex: 1] );
                    [_dragAreas removeLastObject];
                    [_dragAreas addObject: showCard3];
                    [self.view addSubview: showCard3];
                }
            }
            else
                [_dragAreas addObject: showCard1];
        }
        DECK_SHOWN=TRUE;
    }
    else
        
    {
        Card *dealtCard1= [_Deck dealCard : showCard1];
        
        if ( dealtCard1  !=nil)
        {
            // Deal 1 card
            if (SHOW_3_CARDS==FALSE)
            {
                //showCard1.backgroundColor = [UIColor colorWithPatternImage:dealtCard1.cardPic];
                [dealtCard1 drawCardPicture : showCard1  : dealtCard1.cardPic];
                [_Deck updateDeckShownArea : dealtCard1 : 0];
            }
            else
            {
                Card *dealtCard2 = [_Deck dealCard : showCard2];
                if (dealtCard2!=nil )
                {
                    [dealtCard2 drawCardPicture : showCard2  : dealtCard2.cardPic ];
                    
                    [_Deck updateDeckShownArea : dealtCard1 : 1];
                    
                }
                else
                    return ;
                Card *dealtCard3 = [_Deck dealCard : showCard3];
                if (dealtCard3 !=nil)
                {
                    [dealtCard3 drawCardPicture : showCard3  : dealtCard3.cardPic ];
                    [_Deck updateDeckShownArea : dealtCard1 : 2];                }
                else
                    return;
            }
        }
        else
            return;
    }
    // update Deck shown with new card from Deck
    
}






- (void) createAcesArea
{
    int acesArea_YPos = (6 * CARDLENGTH );
    int acesArea_XPos = self.view.bounds.size.width - (4*(CARDWIDTH) + 6*(GAPBETWEENACECARDS));
    for (int i=0; i<(CARDWIDTH+GAPBETWEENACECARDS)*4; i+=CARDWIDTH+GAPBETWEENACECARDS)
    {
        CGRect cardRect = CGRectMake(acesArea_XPos+i, acesArea_YPos, CARDWIDTH,CARDLENGTH);
        //Log(@"Frame cardRect f = %@", NSStringFromCGRect(cardRect));
        
        UIView *aceView = [[UIView alloc] initWithFrame:cardRect];
        aceView.backgroundColor = [UIColor blackColor];
        [[self view] addSubview:aceView];
        [_dropAreas addObject: aceView];
        // //Log(@"create Aces dropAreas Count = %ul",_dropAreas.count);
    }
    //Log(@"create Aces dropAreas Count = %lu",(unsigned long)_dropAreas.count);
}


- (void) createDeckArea
{
    
    CGRect cardRect = CGRectMake(DECKCARD_XPOS, DECKCARD_YPOS, CARDWIDTH,CARDLENGTH);
    UIView *deckView = [[UIView alloc] initWithFrame:cardRect];
    
    deckView.backgroundColor = [UIColor blueColor];
    
    [[self view] addSubview:deckView];
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(tapDetected:)];
    
    [deckView addGestureRecognizer:tapGesture];
    
}




- (void) makeMainCardLayout     // check out subviewe layout
{
    Card *dealtCard;
    
    CGRect aRect;
    float j=15;
    float cardRow=CARDSTARTPOS;
    
    UIView *view1;
    
    for (int cardColumnIndex=0; cardColumnIndex<MAXCARDCOLUMNS; cardColumnIndex++)
    {
        for ( int i=0; i<= cardColumnIndex; i++)
        {
            //       dealtCard = [[Card alloc] init];
            //Log(@" Deck dealcard.cardval %d",dealtCard.cardVal);
            aRect = CGRectMake( j, cardRow, CARDWIDTH, CARDLENGTH);
            view1 = [[UIView alloc] initWithFrame:aRect];
            _Deck.cardRect = aRect;  // assign View made to card
            dealtCard = [_Deck dealCard : view1];  // Deal a Card, Assign View
            
            [_Deck.cardsMainArea addObject: dealtCard]; // add to Main Area
            dealtCard.cardRect = aRect;  // assign View made to card
            [dealtCard drawCardPicture: view1 : CARDREVERSE];
            
            //[self drawCardPicture: view1 : dealtCard.cardPic];
            
            [[self view] addSubview:view1];
            
            cardRow+=CARDLENGTH/2;
        }
        // Section - For Last card Each Column
        j+=CARDWIDTH + GAPBETWEENCARDS;
        cardRow=CARDSTARTPOS;
        
        // Adding last card area in Each column as a draggable area.
        // [_dragAreas addObject:[NSValue valueWithCGRect:aRect]];//Add last Cartd which will be face up as A droppable
        
        //Log(@"viewDidLoad 1 - Adding LAst Card in Column");
        
        [_dragAreas addObject: view1];      // Add last Card in Column to Droppable Area
        [_dropAreas addObject: view1];
        //Log(@"viewDidLoad 2");       // Show its Real Face
        NSString *picFile =[_Deck getPicFileName :dealtCard];
        
        //Log(@"viewDidLoad 2.5 ==> picFile = %@",picFile);
        [dealtCard drawCardPicture : view1 : picFile ];
        
        //Log(@"viewDidLoad 3");
    }
}


-(void) setupAllView
{
    self.view.userInteractionEnabled = YES;
    [self.view setAutoresizesSubviews:YES];
    // dragArea and dropArea -hold Views that
    // can be dragged or dropped to
    _dragAreas=[[NSMutableArray alloc] initWithCapacity:52];
    _dropAreas=[[NSMutableArray alloc] initWithCapacity:52];
    
    // Linking Pan Gesture Recogniser to entire view - as need to make it easier once item is dragged.
    UIPanGestureRecognizer *panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragDetected:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.enabled = YES;
    [self.view addGestureRecognizer:panGesture];
    
       [self  loadHighScore ];
}



#pragma mark - End Of Game Routines and Load/Save HighScore

-(void) EndOfGameAnimation
{
    
    
    //Check if Current Score > HighScore
    // if so
    
    [self saveHighScore  : 9000];//:(NSInteger ) highScoreSec
    //  if (deckCArds NOT Nil)
    //        - animate movement to aCes Area
    //    if (mainCards NOt nil)
    //        - animate movement to aces Area
    
    //for (Card * c in [_Deck mainCardsArea))
    {
        //if (!c.cardFaceUp==TRUE)
        // get Card picture
        //show picture
        
        // Animate Movement
        //     UIView.animateWithDuration(0.5, delay: 0.3, options: nil, animations: {
        //     self.c.cardRect.center.x += self.view.bounds.width
        //     }, completion: nil);
        
        //
        
    }
    
}


-(void) loadHighScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger loadHighScore = [defaults integerForKey:@"HighScore"];
    highScore = loadHighScore;
}



-(void) saveHighScore :(NSInteger ) highScoreSec
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:9001 forKey:@"HighScore"];
    [defaults synchronize];

}









@end