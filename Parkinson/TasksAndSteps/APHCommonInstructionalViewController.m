//
//  APHCommonInstructionalViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 10/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHCommonInstructionalViewController.h"

@interface APHCommonInstructionalViewController  ( ) <UIScrollViewDelegate>

@property  (nonatomic, weak)    IBOutlet  UITextView     *instructionalParagraph;
@property  (nonatomic, weak)    IBOutlet  UIScrollView   *exscrollibur;
@property  (nonatomic, weak)    IBOutlet  UIPageControl  *pager;

@property  (nonatomic, strong)  NSArray  *instructionalImages;
@property  (nonatomic, strong)  NSArray  *nonLocalisedParagraphs;
@property  (nonatomic, strong)  NSArray  *localisedParagraphs;

@property  (nonatomic, assign, getter = wasScrolledViaPageControl)  BOOL  scrolledViaPageControl;

@end

@implementation APHCommonInstructionalViewController

#pragma  mark  -  Initialise Scroll View With Images

- (void)initialiseScrollView
{
    CGSize  contentSize = CGSizeMake(0.0, CGRectGetHeight(self.exscrollibur.frame));
    NSUInteger  imageIndex = 0;
    
    for (NSString  *imageName  in  self.instructionalImages) {
        
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
    self.exscrollibur.pagingEnabled = YES;
    
    self.pager.numberOfPages = [self.instructionalImages count];
}

#pragma  mark  -  Localise Instructional Paragraphs

- (void)initialiseInstructionalParagraphs
{
    NSMutableArray  *localised = [NSMutableArray array];
    
    NSDictionary  *attributes = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize: 17.0],
                                  NSForegroundColorAttributeName : [UIColor grayColor]
                                  };
    
    for (NSString *paragraph  in  self.nonLocalisedParagraphs) {
        NSString  *translated = NSLocalizedString(paragraph, nil);
        NSAttributedString  *styled = [[NSAttributedString alloc] initWithString:translated attributes:attributes];
        [localised addObject:styled];
    }
    self.localisedParagraphs = localised;
}

- (void)setupWithInstructionalImages:(NSArray *)images andParagraphs:(NSArray *)paragraphs
{
    self.instructionalImages = images;
    
    [self initialiseScrollView];
    
    self.nonLocalisedParagraphs = paragraphs;
    [self initialiseInstructionalParagraphs];
    
    [self setupInstruction:0];
}

#pragma  mark  -  Page Control Action Method

- (void)setupInstruction:(NSInteger)pageNumber
{
    self.instructionalParagraph.attributedText = self.localisedParagraphs[pageNumber];
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
