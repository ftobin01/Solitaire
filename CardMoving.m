//
//  CardMoving.m
//  sol1
//
//  Created by F T on 30/05/2015.
//  Copyright (c) 2015 F T. All rights reserved.
//

#import <Foundation/Foundation.h>


- (void)dragDetected: (UIPanGestureRecognizer *)panGestureRecognizer
{
    
    NSLog(@"Drag Dectected 0 ");
    
    
    
    // CGFloat width = CGRectGetWidth(self.view.bounds);
    //CGFloat height = CGRectGetHeight(self.view.bounds);}
    
    /*
     CGPoint locationInView= [panGestureRecognizer translationInView:panGestureRecognizer.view];
     
     [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
     
     // TODO: Here, you should translate your target view using this translation
     UIView *someView.center = CGPointMake(someView.center.x + t.x, someView.center.y + t.y);
     */
    
    
    
    
    NSArray *subviews = [self.view subviews];
    
    
    CGPoint locationInView = [panGestureRecognizer locationInView:self.view];
    
    // CGPoint locationInView= [panGestureRecognizer translationInView:panGestureRecognizer.view];
    
    // [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    
    // TODO: Here, you should translate your target view using this translation
    
    /*
     UIView *tmpView2;
     tmpView2.center = CGPointMake(tmpView2.center.x + locationInView.x, tmpView2.center.y + locationInView.y);
     
     */
    
    float x = locationInView.x;
    float y = locationInView.y;
    static float   dragCardOriginX;
    static float   dragCardOriginY;
    static unsigned long CountOfStartingSubviews=0;
    static UIView *subviewFound=nil;
    
    
    
    UIView *cardInView;
    
    
    //NB if subview dragged is not in draggable list return;
    // means al;l face up cards are added to draggable list
    
    
    dragCardOriginX=0; // viewRect.origin.x;
    dragCardOriginY=0; //  viewRect.origin.y;
    // YES! Found Card to Dra
    //NSLog(@"Found REct  i=%d",i);
    //NSLog("@")
    //NSLog(@"Frame found = %@", NSStringFromCGRect(viewRect));
    
    //  [self.view bringSubviewToFront :subview];
    //subviewFound=subview;
    // subview.backgroundColor = [UIColor blackColor];
    //UIView *tmpView = [[UIView alloc] initWithFrame:viewRect];
    // Find TopMOst view and amke if black.
    //        UIView *ggg  = [subview findTopMostViewForPoint:locationInView];
    // .backgroundColor = [UIColor blackColor];
    //  [self.view addSubview:tmpView];
    
    // we want to gety co-ords from top of current view to bottem
    // of last view placed
    //CountOfStartingSubviews=i;
    switch (panGestureRecognizer.state)
    
    {
            
        case UIGestureRecognizerStateBegan:   //Drag Started
        {
            CGRect rectInView;
            if (CGRectIsEmpty(rectInView = [self inSubViewList: locationInView]) )
            {
                NSLog(@"in SubviewList FALSE- maybe check higher up");
                //panGestureRecognizer.cancelsTouchesInView=YES;
                // panGestureRecognizer.delaysTouchesBegan=YES;
                //panGestureRecognizer.RequiredToFailByGestureRecognize=YES;
                panGestureRecognizer.enabled = NO;                //   [
                //panGestureRecognizer.delaysTouchesEnded=YES;
                break;
            }
            else
            {
                // Need to Check if Pan has occorred in Rects Bounded by CArds Out on Table
                CountOfStartingSubviews=[subviews count];
                NSLog(@"**** UIGestureRecognizerStateBegan - Drag Started %@", NSStringFromCGPoint(locationInView));
                // NSLog(@"My view's frame is: %@", NSStringFromCGRect(self.view.frame));
                NSLog(@" Xpoint is %f",locationInView.x);
                // find view started
                NSLog(@"Subviews count %lu",(unsigned long) [subviews count]);
                NSLog(@"NOW FINd subview Point Location is in....");
                // NSLog(@"Count of number of subviews = %lu",q);
                // -(UIView *)findTopMostViewForPoint : (CGPoint) point
                //*** Need better way
                dragCardOriginX = x -10;//+  ((dragCardOriginX >10) ? -10 : 0);
                dragCardOriginY = y -11; //+  ((dragCardOriginY >10) ? -10 : 0);
                //dragCardOriginX=0;
                //var greeting = "Good" + ((now.getHours() > 17) ? " evening." : " day.");
                
                CGRect tmpRect=CGRectMake( dragCardOriginX,dragCardOriginY , CARDWIDTH, CARDLENGTH) ;
                
                UIView *tmpView = [[UIView alloc] initWithFrame: tmpRect];
                
                
                cardInView.frame=tmpRect;
            }
            
            
        }
            
            break;
        case UIGestureRecognizerStateChanged:  //While Dragging
        {
            unsigned long dropAreaCount = [_dropAreas count];
            
            dragCardOriginX = x -10;//+  ((dragCardOriginX >10) ? -10 : 0);
            dragCardOriginY = y -11; //+  ((dragCardOriginY >10) ? -10 : 0);
            //dragCardOriginX=0;
            //var greeting = "Good" + ((now.getHours() > 17) ? " evening." : " day.");
            NSLog(@"drag detected ==> aSubview.frame = %@  ",NSStringFromCGRect(cardInView.frame));
            
            if ((_cardInPlay =[_Deck  getCardFromSubView : cardInView.frame])==nil)
                NSLog(@"Error - NO Card found from Subview");
            else
                NSLog(@"Card found from Subview = %@" , _cardInPlay.cardPic);
            
            CGRect tmpRect=CGRectMake( dragCardOriginX,dragCardOriginY , CARDWIDTH, CARDLENGTH) ;
            //C dragCardOriginX,dragCardOriginY , CARDWIDTH, CARDLENGTH) ;
            
            UIView *tmpView = [[UIView alloc] initWithFrame: tmpRect];
            
            //   tmpView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: _cardInPlay.cardPic] ];
            
            [self drawCardPicture :  tmpView : _cardInPlay.cardPic];
            
            [self.view addSubview: tmpView];
            
            [self.view setNeedsDisplay];
            
            
            unsigned long topSubviewCount = [subviews count];
            // UIView *topSubview = [subviews objectAtIndex:(int) topSubviewCount];
            //  CGRect  topviewRect =  [topSubview frame];
            // FOUMD
            
            /*  NSLog(@"checking intersection..%lu",CountOfStartingSubviews);
             for (int j= (int) CountOfStartingSubviews-1; j>0; j--)
             {
             UIView *subview = [subviews objectAtIndex:j];
             CGRect checkViewRect=[subview frame];
             if (CGRectIntersectsRect(tmpRect, checkViewRect))
             {
             NSLog(@"Found interection");
             subview.backgroundColor = [UIColor blueColor];
             }
             }
             */
            // MAKE SUBVIEW RED
            NSLog(@"Leaving Drag Detected : dropArea count =  %lu",(unsigned long)[_dropAreas count]);
            NSLog(@"DropAreaCounbt = %lu",dropAreaCount);
            UIColor *colorSave = nil;
            for (int j=0; j<(int) dropAreaCount; j++)
            {
                UIView *dropView = [_dropAreas objectAtIndex:j];
                NSLog(@"Checking dragrect in dropArea %@\nj= %d",dropView,j);
                
                CGRect checkViewRect=[dropView frame];
                NSLog(@"About to compare Intersection of  dropArea j= %d",j);
                
                NSLog(@"tmpRect =%@",NSStringFromCGRect(tmpRect));
                NSLog(@"CheckViewRect =%@",NSStringFromCGRect(checkViewRect));
                
                
                if (CGRectIntersectsRect(tmpRect, checkViewRect))  //they interSect
                {
                    
                    // *** show some animation to show could be dropped...
                    
                    // CGRect newFrame = dropView.frame;
                    CGRect oldFrame = dropView.frame;
                    
                    //  newFrame.size.width  = 40.0f;
                    //  newFrame.size.height = 50.0f;
                    
                    // shift right by 500pts
                    
                    //(void)applyDefaultStyle {
                    // curve the corners
                    
                    /*
                     self.view.layer.cornerRadius = 4;
                     
                     // apply the border
                     self.view.layer.borderWidth = 1.0;
                     self.view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                     
                     // add the drop shadow
                     self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
                     self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0);
                     self.view.layer.shadowOpacity = 0.25;
                     
                     */
                    
                    //   }
                    
                    //      dropView.backgroundColor=[UIColor orangeColor];
                    // dropView.tintColor=[UIColor orangeColor];
                    ;
                    
                    //   dropView.background = dropView.background + [UIColor colorWithWhite:.5 alpha:.5];
                    /*
                     else if you want it to be another color use the general UIColor method: +colorWithRed:green:blue:alpha:
                     */
                    
                    
                    
                    
                    NSLog(@"Found interection....");
                    //dropView.backgroundColor = [UIColor blueColor];
                    // tmpView.backgroundColor  = [UIColor blueColor];
                    /*
                     [UIView animateWithDuration:1.0
                     animations:^{
                     dropView.frame = oldFrame;
                     dropView.frame=oldFrame;                                    }];
                     */
                    // dropView.frame = oldFrame;
                    float hue=.669;
                    float saturation=.3;
                    float brightness=.9;
                    float alpha= .5;
                    
                    //      dropView.backgroundColor=[UIColor colorWithHue: hue
                    //saturation:saturation
                    //brightness: brightness
                    //alpha: alpha];
                    
                }
                /*
                 else
                 {
                 if (dropView.backgroundColor == [UIColor blueColor])
                 {
                 dropView.backgroundColor = RANDOM_COLOR;
                 }
                 }
                 */
                
            }
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:    //Drop - Dragging Ended
        {
            CGPoint dropLocationInView = [panGestureRecognizer locationInView:self.view];
            NSLog(@"DROPPED UIGestureRecogniserStateEnded %@", NSStringFromCGPoint(dropLocationInView));
            
            //DElete All subviews created since Drag Started
            // Delete Forward if dropped on target
            // Delete Backward if nnot found;
            // Check Array of Dropable Areaqs - Eg Aces location - 7 face up card Rectangles
            //          for (UIView *subview in DroppableAreas)
            //          {
            //              CGRect subRect = subview.frame;
            
            
            //          }
            //GET LAWST SUBVIEW
            /*
             unsigned long topSubviewCount = [subviews count];
             UIView *topSubview = [subviews objectAtIndex:(int) topSubviewCount];
             CGRect  topviewRect =  [topSubview frame];
             // FOUMD
             for (int j=0; j< CountOfStartingSubviews-1; j++)
             {
             UIView *subview = [subviews objectAtIndex:j];
             CGRect checkViewRect=[subview frame];
             if (CGRectIntersectsRect(topviewRect, checkViewRect))
             {
             subview.backgroundColor = [UIColor blueColor];
             }
             }
             // MAKE SUBVIEW RED
             
             */
            //Not Found
            unsigned long CurrentSubviewCount = [subviews count];
            NSLog(@"CurrentSubviewCount = %lu, Count ofStartingSubviews= %lu", CurrentSubviewCount ,CountOfStartingSubviews);
            for (int  i=(int) CurrentSubviewCount-(int)1 ; i>= (int) CountOfStartingSubviews; i--)
            {
                
                UIView *subview = [subviews objectAtIndex:i];
                
                [subview removeFromSuperview];
                //[NSThread sleepForTimeInterval:0.6];
                
            }
            // [self.view sendSubviewToBack :subviewFound];
            
            //    for (UIView *dropView in _subviews)
            
            // if (CGRectIntersectsRect(playerRect, mineRect))
            // {
            // OUCH! Found Card to Drag to;
            // }
            
            ;
            /*
             
             [UIView animateWithDuration:.5
             animations:^{
             dropView.frame = oldFrame;
             [self drawCardPicture :  dropView : _cardInPlay.cardPic];
             
             
             }];
             
             */
            
        }
            
            break;
            
        default:
            NSLog(@"Error - Gesture State Not Recognised ");
            break;
    }
    if (panGestureRecognizer.state ==UIGestureRecognizerStateCancelled)
        panGestureRecognizer.enabled = YES;
        
        [self.view setNeedsDisplay];
    
}