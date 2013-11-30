//
//  UIVoicedLabel.m
//  CurrencyConverter
//
//  Created by Nandini  Sundara Raman on 11/29/13.
//  Copyright (c) 2013 Nandini Sundara Raman. All rights reserved.
//

#import "UIVoicedLabel.h"

@implementation UIVoicedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setText:(NSString *)text
{
    NSLog(@"I am at UIVoicedLabel");
    [super setText:text];
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text);
}

@end
