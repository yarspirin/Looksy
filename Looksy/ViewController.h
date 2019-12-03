//
//  ViewController.h
//  UTHCards
//
//  Created by Vladislav Shakhray on 30.11.2019.
//  Copyright © 2019 Vladislav Shakhray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

@interface ViewController : UIViewController <UIScrollViewDelegate, SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainCard;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton2;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UIView *stackView;

@property (nonatomic, strong) NSArray<NSString *> *marketLinks;
@property (nonatomic, strong) NSArray<NSString *> *links;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<NSString *> *prices;
@property (nonatomic, strong) NSArray<NSString *> *brandNames;
@property (nonatomic, strong) NSArray<NSString *> *brandNamesTruncated;

@end

