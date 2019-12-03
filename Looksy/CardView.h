//
//  CardView.h
//  UTHCards
//
//  Created by Vladislav Shakhray on 30.11.2019.
//  Copyright © 2019 Vladislav Shakhray. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *photo;


@end

NS_ASSUME_NONNULL_END
