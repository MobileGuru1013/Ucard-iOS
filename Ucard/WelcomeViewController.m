//
//  WelcomeViewController.m
//  Ucard
//
//  Created by Conner Wu on 15-3-19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "ConfigModel.h"

@interface WelcomeViewController () <UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    UIButton *_startButton;
}
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width;
    CGFloat height;
    
    if(kR35) width=150;
    else if(kR40) width = 170;
    else if(kR47) width = 180;
    else if(kR55) width = 180;
    
    if(kR35) height=20;
    else if(kR40) height = 30;
    else if(kR47) height = 40;
    else if(kR55) height = 40;
    
    
    self.view.backgroundColor = [UIColor colorWithRed:87/255.0 green:172/255.0 blue:123.0/255.0 alpha:1];
    
    NSArray *array = @[@{@"image": @"Welcome1", @"title": @"", @"text": NSLocalizedString(@"localized203", nil)},
                       @{@"image": @"Welcome2", @"title": @"", @"text": NSLocalizedString(@"localized205", nil)},
                       @{@"image": @"Welcome1", @"title": @"", @"text": NSLocalizedString(@"localized207", nil)}];
        

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame) * array.count, CGRectGetHeight(scrollView.frame));
    [self.view addSubview:scrollView];

    for (NSUInteger i = 0 ; i < array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
    
    UIView *viewim = [[UIView alloc] initWithFrame:CGRectMake(0,20, kScreenWidth, kScreenHeight)];
    viewim.backgroundColor=[UIColor clearColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i+75 ,0, kScreenWidth-150, kScreenHeight-width)];
        imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        [viewim addSubview:imageView];

    NSString *title = [dic objectForKey:@"title"];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * i+75 ,CGRectGetMaxY(imageView.frame), kScreenWidth-150, 60)];
        titleLabel.font=[UIFont systemFontOfSize:13];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title.uppercaseString;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumScaleFactor = 0.5;
        [viewim addSubview:titleLabel];
 
          [scrollView addSubview:viewim];
        
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, kScreenHeight - 20 - 10, kScreenWidth, 10.0)];
    _pageControl.numberOfPages = [array count];
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    _pageControl.currentPageIndicatorTintColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:_pageControl];
    
    _startButton = [Constants createGreenButton:CGRectMake(40, CGRectGetMaxY(_pageControl.frame) - height - (kR35 ? 30 : 40), kScreenWidth - 40 * 2, 40) title:NSLocalizedString(@"localized210", nil) sel:@selector(setRootSignin) target:[AppDelegate shareDelegate]];
    _startButton.alpha = 0.0;
    [self.view addSubview:_startButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = (NSInteger)(scrollView.contentOffset.x / kScreenWidth);
    _pageControl.currentPage = currentPage;
    
    CGFloat lastOffX = scrollView.contentSize.width - CGRectGetWidth(scrollView.frame) - scrollView.contentOffset.x;
    if (lastOffX <= CGRectGetWidth(scrollView.frame)) {
        float alpha = (CGRectGetWidth(scrollView.frame) - lastOffX) / CGRectGetWidth(scrollView.frame);
        _startButton.alpha = alpha;
    }
}

@end
