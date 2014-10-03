//
//  APHIntervalTappingIntorViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/16/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHIntervalTappingIntroViewController.h"

static  NSString  *kViewControllerTitle = @"Interval Tapping";

static  NSString  *kIntroHeadingCaption = @"Tests for Bradykinesia";

//static  NSString  *kInstructionalParagraph01 = @"Once you tap get started, you will have 5 seconds before the first interval set appears.";
//static  NSString  *kTapGetStarted = @"Tap “Get Started” to Begin";

@interface APHIntervalTappingIntroViewController  ( )  <UIScrollViewDelegate>

@property  (nonatomic, weak)  IBOutlet  UILabel        *introHeadingCaption;
@property  (nonatomic, weak)  IBOutlet  UITextView     *instructionalParagraph;

@property  (nonatomic, weak)  IBOutlet  UIScrollView   *exscrollibur;
@property  (nonatomic, weak)  IBOutlet  UIPageControl  *pager;
@property  (nonatomic, assign, getter = wasScrolledViaPageControl)  BOOL  scrolledViaPageControl;
@property  (nonatomic, strong)           NSArray       *instructionalParagraphs;

@property  (nonatomic, weak)  IBOutlet  UILabel        *tapGetStarted;

@end

@implementation APHIntervalTappingIntroViewController

#pragma  mark  -  Initialisation

+ (void)initialize
{
    kIntroHeadingCaption = NSLocalizedString(@"Tests Bradykinesia", nil);
}

#pragma  mark  -  Button Action Methods

- (IBAction)getStartedWasTapped:(id)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
            [self.delegate stepViewControllerDidFinish:self navigationDirection:RKStepViewControllerNavigationDirectionForward];
        }
    }
}

#pragma  mark  -  Page Control Action Method

- (void)setupInstruction:(NSInteger)pageNumber
{
    self.instructionalParagraph.attributedText = self.instructionalParagraphs[pageNumber];
    self.instructionalParagraph.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.instructionalParagraph.alpha = 1.0;
    }];
}

- (IBAction)pageControlChangedValue:(UIPageControl *)sender
{
    NSInteger  pageNumber = sender.currentPage;
        //
        //   update scroll view to appropriate page
        //
    CGRect  frame = self.exscrollibur.frame;
    frame.origin.x = CGRectGetWidth(frame) * pageNumber;
    frame.origin.y = 0.0;
    [self.exscrollibur scrollRectToVisible:frame animated:YES];
    
    [self setupInstruction:pageNumber];

    self.scrolledViaPageControl = YES;
}

#pragma  mark  -  Scroll View Delegate Methods

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)sender
{
    self.scrolledViaPageControl = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger  pageNumber = self.pager.currentPage;
    [self setupInstruction:pageNumber];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.wasScrolledViaPageControl == NO) {
        CGFloat  pageWidth = CGRectGetWidth(self.exscrollibur.frame);
        NSInteger  pageNumber = floor((self.exscrollibur.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pager.currentPage = pageNumber;
    }
}

#pragma  mark  -  View Controller Methods

- (void)cancelButtonTapped:(id)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
            [self.delegate stepViewControllerDidCancel:self];
        }
    }
}

- (void)initialiseScrollView
{
    NSArray  *introImageNames = @[ @"interval.instructions.01@2x", @"interval.instructions.02@2x", @"interval.instructions.03@2x", @"interval.instructions.04@2x" ];
    
    CGSize  contentSize = CGSizeMake(0.0, CGRectGetHeight(self.exscrollibur.frame));
    NSUInteger  imageIndex = 0;
    
    for (NSString  *imageName  in  introImageNames) {
        
        NSString   *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage    *anImage = [UIImage imageWithContentsOfFile:imagePath];
        
        CGRect  frame = CGRectMake(imageIndex * CGRectGetWidth(self.exscrollibur.frame), 0.0, CGRectGetWidth(self.exscrollibur.frame), CGRectGetHeight(self.exscrollibur.frame));
        UIImageView  *imager = [[UIImageView alloc] initWithFrame:frame];
        imager.image = anImage;
        [self.exscrollibur addSubview:imager];
        
        contentSize.width = contentSize.width + CGRectGetWidth(self.exscrollibur.frame);
        
        imageIndex = imageIndex + 1;
    }
    self.exscrollibur.contentSize = contentSize;
    
    self.pager.numberOfPages = [introImageNames count];
}

- (void)initialiseInstructionalParagraphs
{
    NSArray  *originals = @[
                                     @"For this task, please lay your phone on a flat surface to produce the most accurate results.",
                                     @"Once you tap “Get Started”, you will have five seconds before the first interval set appears.",
                                     @"Next, use two fingers on the same hand to alternately tap the buttons for 20 seconds.  "
                                     @"Time your taps to be as consistent as possible.",
                                     @"After the intervals are finished, your results will be visible on the next screen."
                                    ];
    
    NSMutableArray  *localised = [NSMutableArray array];
    
    NSDictionary  *attributes = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize: 17.0],
                                  NSForegroundColorAttributeName : [UIColor grayColor]
                                  };

    for (NSString *paragraph  in  originals) {
        NSString  *translated = NSLocalizedString(paragraph, nil);
        NSAttributedString  *styled = [[NSAttributedString alloc] initWithString:translated attributes:attributes];
        [localised addObject:styled];
    }
    self.instructionalParagraphs = localised;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = kViewControllerTitle;
    
    [self initialiseScrollView];
    
    [self initialiseInstructionalParagraphs];
    
    self.introHeadingCaption.text = kIntroHeadingCaption;
    
    self.instructionalParagraph.attributedText = self.instructionalParagraphs[0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = kViewControllerTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.title = kViewControllerTitle;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
