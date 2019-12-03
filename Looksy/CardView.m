//
//  CardView.m
//  UTHCards
//
//  Created by Vladislav Shakhray on 30.11.2019.
//  Copyright © 2019 Vladislav Shakhray. All rights reserved.
//

#import "CardView.h"

@interface CardView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation CardView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void) customInit {
    [[NSBundle mainBundle]loadNibNamed:@"CardXIB" owner:self options:nil];
    
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

@end
