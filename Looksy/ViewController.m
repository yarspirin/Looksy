//
//  ViewController.m
//  UTHCards
//
//  Created by Vladislav Shakhray on 30.11.2019.
//  Copyright © 2019 Vladislav Shakhray. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController ()

@property int selected;
@property bool loveSelected;
@property NSMutableArray<UIView *> *views;
@property NSMutableArray<UIView *> *tints;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selected = 0;
    
//    _links = @[
//    @"https://a.lmcdn.ru/img236x341/M/P/MP002XM248HO_8211822_1_v2.jpg",
//    @"https://a.lmcdn.ru/img236x341/M/P/MP002XM0X3Y0_9988256_1_v2_2x.jpg",
//    @"https://a.lmcdn.ru/img236x341/O/S/OS004EMGOSN1_9373713_1_v1_2x.jpg",
//    @"https://a.lmcdn.ru/img236x341/M/P/MP002XM0X3Y0_9988256_1_v2_2x.jpg",
//    @"https://a.lmcdn.ru/img236x341/O/S/OS004EMGOSN1_9373713_1_v1_2x.jpg"
//    ];
//
//    _brandNames = @[
//        @"La Coste",
//        @"Boss",
//        @"H&M",
//        @"Uniqlo",
//        @"Huy Huy Huy"
//    ];
//
//    _brandNamesTruncated = @[
//        @"lacoste",
//        @"boss",
//        @"hm",
//        @"uniqlo",
//        @"huyhuyhuy",
//    ];
//
//    _titles = @[
//    @"Джемпер",
//    @"Кофта",
//    @"Носки",
//    @"Кофта",
//    @"Носки"
//    ];
//
//    _prices = @[
//        @"1999₽",
//        @"2750₽",
//        @"3330₽",
//        @"2750₽",
//        @"3330₽"
//    ];

//    self.view.backgroundColor = [UIColor colorWithWhite:247./255. alpha:1.];
    
    _scrollView.delegate = self;
//    _loveButton.layer.cornerRadius = 30;
//    _loveButton.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.].CGColor;
//    _loveButton.layer.borderWidth = 2;
    
    _mainCard.layer.cornerRadius = 30;
    _mainCard.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainCard.layer.shadowOpacity = 0.2;
    _mainCard.layer.shadowOffset = CGSizeMake(20, 20);
    _mainCard.layer.shadowRadius = 38;
    
//    _buyButton.backgroundColor = [UIColor colorWithRed:68./255 green:149./255 blue:109./255 alpha:1.];
//    [_buyButton setTitleColor:[UIColor whiteColor] forState:sUIControlStateNormal];
//    _buyButton.layer.cornerRadius = 30;
//    
//    _buyButton.layer.cornerRadius = 30;
//    _buyButton.layer.borderColor = [UIColor colorWithRed:57./255 green:134./255 blue:241./255 alpha:.9].CGColor;
//    _buyButton.layer.borderWidth = 2;
    _photo.layer.cornerRadius = 30;
//    [_loveButton addTarget:self action:@selector(love:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
     [_buyButton2 addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    
    _stackView.layer.shadowColor = [UIColor blackColor].CGColor;
    _stackView.layer.shadowOpacity = 0.4;
    _stackView.layer.shadowOffset = CGSizeMake(10, 10);
    _stackView.layer.shadowRadius = 24;
    
    CGFloat border = 48;
    CGFloat between = 42;
    CGFloat width = 120;
    
//    CGFloat gradHeight = 300;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _photo.frame.size.height - gradHeight, _photo.frame.size.width, gradHeight)];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//
//    gradient.frame = view.bounds;
//    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:0. alpha:0.6].CGColor];
//
//    [view.layer insertSublayer:gradient atIndex:0];
//
//    [_photo addSubview:view];
    
    
    _brandLogo.frame = _brandLabel.frame;
    
    NSMutableArray<UIView *> *views = [NSMutableArray new];
    
    _tints = [NSMutableArray new];
    for (int i = 0; i < _titles.count; i++) {
        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(border + (i * (width + between)), 0, width, _scrollView.frame.size.height)];
        newView.backgroundColor = [UIColor blackColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, newView.frame.size.height)];
        imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_links[i]]]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [newView addSubview:imgView];
        
        newView.layer.cornerRadius = 20;
        newView.clipsToBounds = YES;
        
        newView.layer.borderColor = [UIColor colorWithWhite:i == 0 ? 1 : 0.9 alpha:1.].CGColor;
        newView.layer.borderWidth = (i == 0) ? 2 : 1;
        
        CGFloat priceWidth = 80;
        CGFloat priceHeight = 30;
        CGFloat cornerRadius = 15.;
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(newView.frame.size.width - priceWidth, newView.frame.size.height - priceHeight, priceWidth, priceHeight)];
        
        UIButton *button = [[UIButton alloc]initWithFrame:newView.bounds];
        button.tag = i;
    
        [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
        priceLabel.backgroundColor = [UIColor whiteColor];
        
        UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:priceLabel.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];

        maskLayer.frame = priceLabel.bounds;
        maskLayer.path = bp.CGPath;

        priceLabel.layer.mask = maskLayer;
        priceLabel.textAlignment = NSTextAlignmentCenter;
        
        priceLabel.font = [UIFont fontWithName:@"Futura" size:15.];
        priceLabel.text = _prices[i];
        
        UIView *tint = [[UIView alloc]initWithFrame:newView.bounds];
        tint.backgroundColor = [UIColor colorWithWhite:0. alpha:0.075];
        tint.hidden = YES;
        
        [newView addSubview:tint];
        [newView addSubview:button];
        [newView addSubview:priceLabel];
        [views addObject:newView];
        
        [_tints addObject:tint];
    }
    
    _scrollView.contentSize = CGSizeMake(2 * border + between * (_titles.count - 1) + width * _titles.count, _scrollView.frame.size.height);

    for (UIView *view in views) {
        [_scrollView addSubview:view];
    }
    
    _views = views;
}

- (void)buy:(UIButton *)button {
    SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:_marketLinks[_selected]]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
//        CGFloat sz = 200;
//        UIImageView *gif = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2. - sz / 2., self.view.frame.size.height/2. - sz / 2., sz, sz)];
//        UIImage *img = [UIImage imageNamed:@"frame"];
//        gif.image = img;
////        NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"gif.gif" withExtension:@"gif"]];
////        gif.animationImages = [NSArray arrayWithObjects:img, nil];
////        gif.animationDuration = 1.;
////        gif.animationRepeatCount = 10;
//        [self.view addSubview:gif];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Спасибо за покупку!"
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleAlert];

        //Add Buttons

        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"ОК"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
//                                        [self ];
                                    }];

//        UIAlertAction* noButton = [UIAlertAction
//                                   actionWithTitle:@"Cancel"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action) {
//                                       //Handle no, thanks button
//                                   }];

        //Add your buttons to alert controller

        [alert addAction:yesButton];
//        [alert addAction:noButton];

        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)love:(UIButton *)button {
//    if (_loveSelected) {
//        [_loveButton setBackgroundColor:[UIColor whiteColor]];
//        _loveSelected = NO;
//        _loveButton.layer.cornerRadius = 30;
//        _loveButton.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.].CGColor;
//        _loveButton.layer.borderWidth = 2;
//    } else {
//        [_loveButton setBackgroundColor:[UIColor colorWithRed:57./255 green:134./255 blue:241./255 alpha:.9]];
//        _loveSelected = YES;
//        _loveButton.layer.cornerRadius = 30;
//        _loveButton.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1.].CGColor;
//        _loveButton.layer.borderWidth = 0.;
//    }
}

- (void) change:(UIButton *)button {
    _views[_selected].layer.borderWidth = 0;
    _tints[_selected].hidden = YES;
    _selected = button.tag;
    [self updateState];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateState];
}

- (void)updateState {
    _tints[_selected].hidden = NO;
    _views[_selected].layer.borderWidth = 2;
    _views[_selected].layer.borderColor = [UIColor colorWithWhite:0. alpha:0.6].CGColor;

    [_buyButton setTitle:_prices[_selected] forState:UIControlStateNormal];
    
    UIImage *brandLogo = [UIImage imageNamed:_brandNamesTruncated[_selected]];
    if (brandLogo) {
        _brandLabel.hidden = YES;
        _brandLogo.hidden = NO;
        _brandLogo.image = brandLogo;
    } else {
        _brandLabel.hidden = NO;
        _brandLogo.hidden = YES;
        _brandLabel.text = _brandNames[_selected];

    }
//    _titleLabel.text = _titles[_selected];
    _photo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_links[_selected]]]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;

    [_photo.layer addAnimation:transition forKey:nil];
}

@end
