//
//  UIButton+XBExtension.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 9/5/15.
//
//

#import "UIButton+XBExtension.h"

@implementation UIButton (XBExtension)
@dynamic imageName;
@dynamic title;

- (void)setImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (NSString *)imageName
{
    return nil;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    [self setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
}

- (NSString *)backgroundImageName
{
    return nil;
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title
{
    [self titleForState:UIControlStateNormal];
}

@end
